class_name Cursor extends Node2D
static var ref: Cursor
func _init() -> void:
	ref = self
	
signal clickable_hovered()
	
var _hovered_clickable: Clickable
var _active: bool = true

var _cursor_state: CURSOR_STATES = CURSOR_STATES.NONE
enum CURSOR_STATES{
	NONE,HOVERING_CLICKABLE,AWAITING_ACTION,ACTION_COMPLETE
	}

func is_cursor_state(which:CURSOR_STATES) -> bool:
	return which == _cursor_state
func change_cursor_state(to:CURSOR_STATES) -> void:
	if not to == CURSOR_STATES.ACTION_COMPLETE:
		if _cursor_state == CURSOR_STATES.AWAITING_ACTION:
			return
		
	#if not to == CURSOR_STATES.NONE:
		#print("Cursor is trying to change to the ",CURSOR_STATES.find_key(to)," state...")
	if _cursor_state == to:
		return
	
	
	if not _active and not to == CURSOR_STATES.ACTION_COMPLETE:
		return
	
	if to == CURSOR_STATES.AWAITING_ACTION:
		_cursor_state = to
		print_rich("[b][font_size=20]Cursor state is now ",CURSOR_STATES.find_key(to),"!")
		_on_awaiting_action()
		return
	
	_cursor_state = to
	print_rich("[b]Cursor state is now ",CURSOR_STATES.find_key(to),"!")
	match _cursor_state:
		CURSOR_STATES.NONE:
			_on_none()
		CURSOR_STATES.HOVERING_CLICKABLE:
			_on_hovering_clickable()
		CURSOR_STATES.ACTION_COMPLETE:
			_on_action_complete()
			
	
@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		click()
		
func click() -> void:
	if not _active:
		return
		
	_sprite.play("click")
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	Player.ref.on_click(mouse_pos)
	

func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
func set_active(indeed:bool) -> void:
	_active = indeed
func is_active() -> bool:
	return _active
func cursor_action_started() -> void:
	print("CURSOR ACTION STARTED")
	Cursor.ref.change_cursor_state(
		Cursor.CURSOR_STATES.AWAITING_ACTION)
func cursor_action_complete() -> void:
	change_cursor_state(CURSOR_STATES.ACTION_COMPLETE)
	
func _on_none() -> void:
	print("CURSOR HOVER NONE")
	_hovered_clickable = null
	
func _on_hovering_clickable() -> void:
	print("hovering a clickable...")
	clickable_hovered.emit()

func _on_awaiting_action() -> void:
	print("awaiting a clicked object to be actioned...")
	
func _on_action_complete() -> void:
	change_cursor_state(CURSOR_STATES.NONE)

func set_hovered_clickable(what: Clickable) -> void:
	_hovered_clickable = what
	print("Cursor saw ", _hovered_clickable.name)

func get_hovered_clickable() -> Clickable:
	return _hovered_clickable
