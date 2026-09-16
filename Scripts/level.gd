class_name Level extends Node2D
static var ref: Level
func _init() -> void:
	ref = self

func darken(indeed:bool) -> void:
	if indeed:
		modulate = Color("Black")
