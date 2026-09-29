class_name Player_RobotPart extends Node2D

@export var _part: Manage_RobotParts.PARTS = Manage_RobotParts.PARTS.NULL

@onready var _area: Area2D = %Area2D

@onready var _part_sprite: Sprite2D = %RobotPart_Sprite2D

func _ready() -> void:
	_ready_connections()
	_ready_part()

func _ready_connections() -> void:
	_area.body_entered.connect(_on_body_entered)
	
func _ready_part() -> void:
	var parts: Array[Manage_RobotParts.PARTS] = [
	]
	var parts_registry: Dictionary[Manage_RobotParts.PARTS,Dictionary] = \
		Manage_RobotParts.ref.get_registry()
	parts.assign(parts_registry.keys())
	parts.shuffle()
	for part in parts:
		var already_spawned: bool = \
			Manage_RobotParts.ref.check_registry(
				part,
				Manage_RobotParts.PARTS_CONTENT.SPAWNED)
		if already_spawned:
			continue
		_set_sprite(part)
		Manage_RobotParts.ref.update_registry(
			part,
			Manage_RobotParts.PARTS_CONTENT.SPAWNED,
			true)
	
func _set_sprite(to_what:Manage_RobotParts.PARTS) -> void:
	_part_sprite.texture = \
		Manage_RobotParts.ref.check_registry(
			to_what,
			Manage_RobotParts.PARTS_CONTENT.TEXTURE)
	
func _on_body_entered(body:PhysicsBody2D) -> void:
	if body is Player:
		Manage_RobotParts.ref.update_registry(
			_part,
			Manage_RobotParts.PARTS_CONTENT.COLLECTED,
			true)
		queue_free()
