class_name Monster_Death extends Node2D

@onready var _animation: AnimationPlayer = %AnimationPlayer

func die() -> void:
	show()
	Cursor.ref.hide()
	Walk_Target.ref.hide()
	_animation.play("die")
	get_tree().paused = true
