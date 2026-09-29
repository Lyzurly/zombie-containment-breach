class_name Player_RobotPart extends PanelContainer

enum PARTS{NULL,BODY,LEG_L,LEG_R,ARM_L,ARM_R}
@export var _part: PARTS = PARTS.NULL

var _my_texture: TextureRect
var _collected: bool = false

func _ready() -> void:
	Manage_RobotParts.ref.collected_part.connect(
		_on_collected_part)
	_ready_texture()
	
func _ready_texture() -> void:
	match _part:
		PARTS.BODY:
			_my_texture = %PartBody_TextureRect
		PARTS.LEG_L:
			_my_texture = %PartLegL_TextureRect
		PARTS.LEG_R:
			_my_texture = %PartLegR_TextureRect
		PARTS.ARM_L:
			_my_texture = %PartArmL_TextureRect
		PARTS.ARM_R:
			print("ARM RIGHT IS SHOWING UP")
			_my_texture = %PartArmR_TextureRect
			
func _on_collected_part(which_part:PARTS) -> void:
	if _part == which_part:
		_my_texture.modulate = Color("White")
