class_name Camera extends Camera2D
static var ref: Camera
func _init() -> void:
	ref = self
	
const _MOVE_SPEED: float = .6
const _POS_HORIZ: float = 382.
	
var tween:Tween

func move(
to_zone:Camera_Zones.ZONES
) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	var to_where: Vector2
	match to_zone:
		Camera_Zones.ZONES.LEFT:
			to_where = Vector2(-_POS_HORIZ,0)
		Camera_Zones.ZONES.MID:
			to_where = Vector2(0.,0)
		Camera_Zones.ZONES.RIGHT:
			to_where = Vector2(_POS_HORIZ,0)
	
	tween.tween_property(self,"offset",to_where,_MOVE_SPEED)
	
