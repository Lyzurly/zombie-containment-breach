class_name Cursor extends Node2D
static var ref: Cursor
func _init() -> void:
	ref = self
	
signal clickable_hovered()
	
var _hovered_clickable: Clickable

var _cursor_state: CURSOR_STATES = CURSOR_STATES.NONE
enum CURSOR_STATES{
	NONE,HOVERING_CLICKABLE,
	}

func is_cursor_state(which:CURSOR_STATES) -> bool:
	return which == _cursor_state
func change_cursor_state(to:CURSOR_STATES) -> void:
	#if not to == CURSOR_STATES.NONE:
		#print("Cursor is trying to change to the ",CURSOR_STATES.find_key(to)," state...")
	if _cursor_state == to:
		return
	#if to == CURSOR_STATES.NONE:
		#return
	
	_cursor_state = to
	
	match _cursor_state:
		CURSOR_STATES.NONE:
			_on_none()
		CURSOR_STATES.HOVERING_CLICKABLE:
			_on_hovering_clickable()
			
	
@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		_sprite.play("click")

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
func _on_none() -> void:
	print("CURSOR HOVER NONE")
	_hovered_clickable = null
	
func _on_hovering_clickable() -> void:
	print("hovering a clickable...")
	clickable_hovered.emit()

func set_hovered_clickable(what: Clickable) -> void:
	_hovered_clickable = what
	print("Cursor saw ", _hovered_clickable.name)

func get_hovered_clickable() -> Clickable:
	return _hovered_clickable
