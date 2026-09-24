class_name Camera_Zones extends Node2D
static var ref: Camera_Zones
func _init() -> void:
	ref = self

var _current_zone: ZONES = ZONES.NONE
enum ZONES{NONE,MID,LEFT,RIGHT,TOP}

@onready var _left_area: Area2D = %Room_Left_Area2D
@onready var _mid_area: Area2D = %Room_Mid_Area2D
@onready var _right_area: Area2D = %Room_Right_Area2D

func _ready() -> void:
	print("AREAS READY")
	Manage_Room.ref.reset_room.connect(_on_reset_room)
	_left_area.body_entered.connect(
		_on_body_entered.bind(ZONES.LEFT))
	_mid_area.body_entered.connect(
		_on_body_entered.bind(ZONES.MID))
	_right_area.body_entered.connect(
		_on_body_entered.bind(ZONES.RIGHT))

func is_zone(which:ZONES) -> bool:
	return which == _current_zone
func get_current_zone() -> ZONES:
	return _current_zone

func _change_zone(to:ZONES) -> void:
	if _current_zone == to:
		return
	
	_current_zone = to
	print("Player is in area ",ZONES.find_key(_current_zone))
	
	match to:
		ZONES.MID:
			_on_mid_zone()
		ZONES.LEFT:
			_on_left_zone()
		ZONES.RIGHT:
			_on_right_zone()


func _on_body_entered(
body:PhysicsBody2D,
zone:ZONES
) -> void:
	if body is Player:
		_change_zone(zone)

func _on_mid_zone() -> void:
	Camera.ref.move(ZONES.MID)

func _on_left_zone() -> void:
	Camera.ref.move(ZONES.LEFT)

func _on_right_zone() -> void:
	Camera.ref.move(ZONES.RIGHT)

func _on_reset_room(_which_room:Level_Room) -> void:
	_change_zone(ZONES.NONE)
