class_name Level extends Node2D
static var ref: Level
func _init() -> void:
	ref = self
	
signal level_faded
	
const _PLAYER: PackedScene = preload("uid://bl3lborhje03c")
const _PLAYER_SPAWN_POS: Vector2 = Vector2(-255,0)

const _FADE_SPEED: float = .5
const _FADE_OUT_DELAY: float = .7
var _tween: Tween

func _ready() -> void:
	Manage_Game.ref.change_game_state(
		Manage_Game.GAME_STATES.GAMEPLAY) 

func add_player() -> void:
	var player: Node2D = \
		_PLAYER.instantiate()
	get_parent().add_child.call_deferred(player)
	player.global_position = _PLAYER_SPAWN_POS

func darken(by_what:Clickable,indeed:bool) -> void:
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	var color: Color = \
		Color("Black") if indeed else Color("White")
	var delay: float = \
		0. if indeed else _FADE_OUT_DELAY
	
	_tween.tween_property(
		self,"modulate",
		color,
		_FADE_SPEED
	).set_delay(delay)
	
	if indeed:
		Cursor.ref.set_active(false)
		Cursor.ref.change_cursor_state(
			Cursor.CURSOR_STATES.NONE)
		
		print_rich("[font_size=20][b]CURSOR IS GONE!!")
	
	
	_tween.finished.connect(
		_on_darkened.bind(by_what,indeed),CONNECT_ONE_SHOT)

func _on_darkened(by_what:Clickable,indeed:bool) -> void:
	if indeed:
		level_faded.emit()
		darken(by_what,false)
	else:
		by_what.action_complete()
		Cursor.ref.set_active(true)
		print_rich("[font_size=20][b]CURSOR IS SO BACK")
		
	
	
