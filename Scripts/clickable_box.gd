class_name Clickable_Box extends Clickable

@onready var _closed_sprite: Sprite2D = $Closed_Sprite2D
@onready var _open_sprite: Sprite2D = %Open_Sprite2D
@onready var _key_sprite: Sprite2D = %Key_Sprite2D


func _my_sprite() -> Sprite2D:
	#print(self," reports it having the sprite ",$Closed_Sprite2D)
	return $Closed_Sprite2D

func _on_click(
click_count:int,
_while_holding:HOLDABLES
) -> void:
	if click_count == 1:
		_closed_sprite.hide()
		_open_sprite.show()
		var coin_flip: float = randf_range(-1,1.1)
		if coin_flip <= 0:
			_key_sprite.visible = true
			
			#Monster.ref.queue_free()
			Win_Label.ref.visible = true
			#await get_tree().create_timer(5.)
			#get_tree().reload_current_scene()
