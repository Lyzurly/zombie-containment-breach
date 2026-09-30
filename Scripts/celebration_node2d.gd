class_name Player_Celebration extends Node2D

@onready var _celebration_animation: AnimationPlayer = %Celebration_AnimationPlayer

func celebrate() -> void:
	show()
	Cursor.ref.hide()
	_celebration_animation.play("celebrate")
	get_tree().paused = true
	await get_tree().create_timer(5).timeout
	get_tree().paused = false
	hide()
	_celebration_animation.stop()
	Player.ref.z_on_top(false)
	Cursor.ref.show()
