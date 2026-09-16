class_name Player extends CharacterBody2D
static var ref: Player
func _init() -> void:
	ref = self

@onready var _debug_label: Label = %Debug_Label
@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D

var _holding: Clickable.HOLDABLES = Clickable.HOLDABLES.NOTHING
var _clickable_to_activate: Clickable

var _move_state: MOVE_STATES = MOVE_STATES.IDLE
enum MOVE_STATES{
	IDLE,WALK_LEFT,WALK_RIGHT
	}
	
var _dir_state: DIR_STATES = DIR_STATES.NONE
enum DIR_STATES{
	NONE,LEFT,RIGHT
	}

var SPEED = 75.0
const JUMP_VELOCITY = -600.0

func _ready() -> void:
	_change_move_state(MOVE_STATES.IDLE)


func _is_dir_state(which:DIR_STATES) -> bool:
	return which == _dir_state
func _change_dir_state(to:DIR_STATES) -> void:
	if _dir_state == to:
		return
	_dir_state = to
	
	match _dir_state:
		DIR_STATES.LEFT:
			_on_left()
		DIR_STATES.RIGHT:
			_on_right()
	

func _is_move_state(which:MOVE_STATES) -> bool:
	return which == _move_state
func _change_move_state(to:MOVE_STATES) -> void:
	if _move_state == to:
		return
	_move_state = to
	
	match _move_state:
		MOVE_STATES.IDLE:
			_sprite.play("idle")
		MOVE_STATES.WALK_LEFT,MOVE_STATES.WALK_RIGHT:
			_sprite.play("walk")
			match _move_state:
				MOVE_STATES.WALK_LEFT:
					_on_walk_left()
				MOVE_STATES.WALK_RIGHT:
					_on_walk_right()
	


func _physics_process(delta: float) -> void:
	_physics_process_mouse()
	_physics_process_moving(delta)

func _physics_process_mouse() -> void:
	#print("Mouse pos: ",get_global_mouse_position(),
			#"\n\tPlayer pos: ",global_position)
			
	if not Manage_Game.ref.is_state(
		Manage_Game.GAME_STATES.GAMEPLAY
		):
			return
		
	var mouse_pos: Vector2 = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		_change_dir_state(DIR_STATES.LEFT)
	else:
		_change_dir_state(DIR_STATES.RIGHT)
	
	if Input.is_action_just_pressed("Click"):
		_on_click(mouse_pos)
	

func _physics_process_moving(delta: float) ->  void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		SPEED = 100.

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		SPEED = 75.

	var direction: float = 0.

	if _is_move_state(MOVE_STATES.WALK_LEFT):
		direction = -1.
		if Walk_Target.ref.is_activated():
			#print("Player knows walk target is activated...")
			if global_position.x < Walk_Target.ref.get_horizontal_pos():
				direction = 0.
				Walk_Target.ref.activate(false)
				if _clickable_to_activate:
					_clickable_to_activate.click(_holding)
					_clickable_to_activate = null
				
	elif _is_move_state(MOVE_STATES.WALK_RIGHT):
		direction = 1.
		if Walk_Target.ref.is_activated():
			#print("Player knows walk target is activated...")
			if global_position.x > Walk_Target.ref.get_horizontal_pos():
				direction = 0.
				Walk_Target.ref.activate(false)
				print("stopped walking right; clickable is ",_clickable_to_activate)
				if _clickable_to_activate:
					_clickable_to_activate.click(_holding)
					_clickable_to_activate = null
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_equal_approx(velocity.x,0.):
		_change_move_state(MOVE_STATES.IDLE)

	move_and_slide()
	
func _on_click(mouse_pos:Vector2) -> void:
	if Cursor.ref.is_cursor_state(
	Cursor.CURSOR_STATES.HOVERING_CLICKABLE
	):
		var clickable: Clickable = Cursor.ref.get_hovered_clickable()
		if not clickable:
			push_error("WHERE DA CLICKABLE")
			return
		_clickable_to_activate = clickable
		print("Player clicked ",_clickable_to_activate.name)
		
		
	Walk_Target.ref.activate(true,mouse_pos)
	if _is_dir_state(DIR_STATES.LEFT):
		_change_move_state(MOVE_STATES.WALK_LEFT)
	elif _is_dir_state(DIR_STATES.RIGHT):
		_change_move_state(MOVE_STATES.WALK_RIGHT)

func _on_left() -> void:
	_debug_label.text = "left"
func _on_right() -> void:
	_debug_label.text = "right"

func _on_walk_left() -> void:
	_sprite.flip_h = true
func _on_walk_right() -> void:
	_sprite.flip_h = false
