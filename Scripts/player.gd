class_name Player extends CharacterBody2D
static var ref: Player
func _init() -> void:
	ref = self

@onready var _debug_label: Label = %Debug_Label
@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D

var _holding: Clickable.HOLDABLES = Clickable.HOLDABLES.NOTHING
var _clickable_to_activate: Clickable

var _move_state: MOVE_STATES = MOVE_STATES.NONE
enum MOVE_STATES{
	NONE,IDLE,WALK_LEFT,WALK_RIGHT
	}
	
var _dir_state: DIR_STATES = DIR_STATES.NONE
enum DIR_STATES{
	NONE,LEFT,RIGHT
	}

var SPEED = 75.0
const JUMP_VELOCITY = -600.0

func _ready() -> void:
	print("PLAYER READY")
	_ready_connections()
	_ready_initial_states()
	
func _ready_connections() -> void:
	Manage_Room.ref.reset_room.connect(_on_reset_room)

func _ready_initial_states() -> void:
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
		Cursor.ref.click()
	

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
					#TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					#I want the clicked thing to stay the clicked thing even after cursor leaves the thing. Commenting this back in will softlock in cursor action awaiting.		
					#TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					#_clickable_to_activate = null
				
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
					#TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					#I want the clicked thing to stay the clicked thing even after cursor leaves the thing. Commenting this back in will softlock in cursor action awaiting.		
					#TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					 #TODO #TODO #TODO #TODO #TODO #TODO
					#_clickable_to_activate = null
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_equal_approx(velocity.x,0.):
		_change_move_state(MOVE_STATES.IDLE)

	move_and_slide()
	
func on_click(mouse_pos:Vector2) -> void:
	if Cursor.ref.is_cursor_state(
	Cursor.CURSOR_STATES.HOVERING_CLICKABLE
	):
		var clickable: Clickable = Cursor.ref.get_hovered_clickable()
		if not clickable:
			push_error("WHERE DA CLICKABLE")
			return
		
		_clickable_to_activate = clickable
		print("Player clicked ",_clickable_to_activate.name)
		
		Cursor.ref.cursor_action_started()
		
		
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

func _on_reset_room(_which_room:Level_Room) -> void:
	# Layer 3 = Player Camera Zone Detection
	set_collision_layer_value(3,false)
	var door: Clickable = \
		Manage_Room.ref.get_last_door()
	print("HERE DA DOOR ",door)
	global_position.x = door.global_position.x
	# Layer 3 = Player Camera Zone Detection
	await get_tree().process_frame
	set_collision_layer_value(3,true)
