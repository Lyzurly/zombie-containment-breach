class_name Manage_HUD extends Node
static var ref: Manage_HUD
func _init() -> void:
	ref = self
	
var _placeholders: Array[Control] = []

#@onready var _hud_container: MarginContainer = %HUD_MarginContainer
#

func _ready() -> void:
	_ready_placeholders()

func _ready_placeholders() -> void:
	_placeholders = [
		%Placeholder_Label1,%Placeholder_Label2
	]
	
	for placeholder in _placeholders:
		placeholder.modulate.a = 0.
