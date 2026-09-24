class_name Monster extends Node2D
	
const SPEED: float = 50.
const _SPAWN_X_POS: float = 700.

func _ready() -> void:
	print("MONSTER READY")
	%Area2D.body_entered.connect(_on_body_entered)
	%AnimatedSprite2D.play("run")
	Manage_Room.ref.reset_room.connect(_on_reset_room)
	
	
func _physics_process(delta: float) -> void:
	global_position.x = move_toward(global_position.x,Player.ref.global_position.x,delta * SPEED)
	if Player.ref.global_position < global_position:
		%AnimatedSprite2D.flip_h = false
	else:
		%AnimatedSprite2D.flip_h = true

func move_to_spawn_pos() -> void:
	var spawn_pos: Vector2 = Vector2(0,0)
	#print("Current camera zone is ",
		#Camera_Zones.ZONES.find_key(Camera_Zones.ref.get_current_zone()))
	match Camera_Zones.ref.get_current_zone():
		Camera_Zones.ZONES.LEFT:
			spawn_pos.x = _SPAWN_X_POS
		Camera_Zones.ZONES.RIGHT:
			spawn_pos.x = -_SPAWN_X_POS
		Camera_Zones.ZONES.MID:
			if Player.ref.global_position.x > 0:
				spawn_pos.x = -_SPAWN_X_POS
			else:
				spawn_pos.x = _SPAWN_X_POS
	global_position = spawn_pos
	#print("MONSTER IS AT ",global_position)
			

func _on_body_entered(body:PhysicsBody2D) -> void:
	if body is Player:
		await get_tree().process_frame
		get_tree().reload_current_scene()

func _on_reset_room(_which_room:Level_Room) -> void:
	queue_free()
