class_name Clickable_Door extends Door

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	super._ready()
	_animated_sprite.animation_finished.connect(_on_animation_finished)
	Manage_Room.ref.door_opened.connect(_on_door_opened)
	Manage_RobotParts.ref.collected_all_parts.connect(_on_collected_all_parts)

func _my_sprite() -> Sprite2D:
	return %ClickArea_Sprite2D
func _on_reset() -> void:
	_animated_sprite.stop()

func _can_spawn_robot_part() -> bool:
	return false

func _on_click(
clicks:int,_while_holding:HOLDABLES
) -> void:
	if clicks >= 1 and _hovered:
		print_rich("[font_size=20]",self.name,"CLICKED")
		_animated_sprite.play("open")
		
func _on_action_complete() -> void:
	print("AWAITING OVER")
	Cursor.ref.cursor_action_complete()
	
func _on_cursor_completed_action(_for_what:Clickable) -> void:
	pass
		
func _on_animation_finished() -> void:
	Manage_Room.ref.door_opened.emit(self,_door_id)

func _on_door_opened(door: Door, id:int) -> void:
	print(self,"checked for doorage")
	if _door_id == id and not door == self:
		var parent: Variant = get_parent()
		print("DOOR PARENT IS ",parent)
		if parent is Level_Room:
			Manage_Room.ref.change_room(door,parent,true)
			Manage_Room.ref.set_last_door(self)
			
	#else:
		#push_error(
			#"WHOOPSIE COULDN'T FIND A VALID DOOR TARGET"
		#)

func _on_collected_all_parts() -> void:
	make_unclickable()
