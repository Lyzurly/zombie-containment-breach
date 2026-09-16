class_name Clickable_Door extends Door

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	super._ready()
	_animated_sprite.animation_finished.connect(_on_animation_finished)

func _my_sprite() -> Sprite2D:
	return %ClickArea_Sprite2D

func _on_click(
clicks:int,_while_holding:HOLDABLES
) -> void:
	if clicks == 1:
		#print("IT'S HAPPENING")
		_animated_sprite.play("open")
		
func _on_animation_finished() -> void:
	#TODO TODO TODO TODO
	#TODO TODO TODO TODO
		# SEND WHAT DOOR IT IS
		# SO IT KNOWS WHERE TO GO
		# SEND IT TO MANAGE ROOM
	#TODO TODO TODO TODO
	#TODO TODO TODO TODO
	Manage_Room.ref.change_room(true)
