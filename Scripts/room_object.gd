@abstract class_name Room_Object extends Clickable

@abstract func _on_reset()

func reset() -> void:
	_hovered = false
	print_rich("[font_size=20]",self.name,"RESET, HOVER=FALSE")
	_on_reset()

func can_hover() -> bool:
	var parent: Variant = get_parent()
	if parent is Level_Room:
		var room: Level_Room = parent as Level_Room
		return room.is_active()
	return false
