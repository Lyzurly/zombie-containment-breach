class_name Player_RobotPart extends PanelContainer

enum PARTS{NULL,BODY,LEG_L,LEG_R,ARM_L,ARM_R}
@export var _part: PARTS = PARTS.NULL

const _COLLECTED_STYLEBOX: StyleBoxFlat = preload("uid://csbir8idnku1o")
const _ANIMATION_SPEED: float = .3

var _my_texture: TextureRect
var _collected: bool = false

func _ready() -> void:
	Manage_RobotParts.ref.collected_part.connect(
		_on_collected_part)
	Manage_RobotParts.ref.collected_all_parts.connect(
		_on_collected_all_parts)
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
		_animate_part()
		add_theme_stylebox_override("panel",_COLLECTED_STYLEBOX)
		
func _animate_part() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,"offset_transform_scale",
		Vector2(2.5,2.5),_ANIMATION_SPEED)
	tween.tween_property(
		self,"offset_transform_scale",
		Vector2(1.,1.),_ANIMATION_SPEED).set_delay(_ANIMATION_SPEED)
	
func _on_collected_all_parts() -> void:
	await get_tree().create_timer(_ANIMATION_SPEED*3).timeout
	_animate_part()
		
