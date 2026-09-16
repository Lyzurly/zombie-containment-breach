class_name Walk_Target extends Node2D
static var ref: Walk_Target
func _init() -> void:
	ref = self

@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D

var _activated: bool = false

func _ready() -> void:
	pass
	
func get_horizontal_pos() -> float:
	return global_position.x

func is_activated() -> bool:
	return _activated
	
func activate(indeed: bool, where:Vector2=Vector2.ZERO) -> void:
	_activated = indeed 
	visible = indeed
	
	global_position = where
	
	if indeed:
		_sprite.play("click_loop")
	else:
		_sprite.stop()
