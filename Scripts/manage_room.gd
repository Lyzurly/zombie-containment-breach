class_name Manage_Room extends Node
static var ref: Manage_Room
func _init() -> void:
	ref = self
	
func change_room(indeed:bool) -> void:
	Level.ref.darken(indeed)
	if indeed:
		pass
