class_name Level extends Node2D
static var ref: Level
func _init() -> void:
	ref = self
	
var _tween: Tween
const _FADE_SPEED: float = .5


func darken(indeed:bool) -> void:
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	var color: Color = \
		Color("Black") if indeed else Color("White")
	var delay: float = \
		0. if indeed else .75
	
	_tween.tween_property(
		self,"modulate",
		color,
		_FADE_SPEED
	).set_delay(delay)
	_tween.finished.connect(_on_darkened,CONNECT_ONE_SHOT)

func _on_darkened() -> void:
	darken(false)
	
	
