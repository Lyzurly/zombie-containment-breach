class_name Monster extends Node2D
	
const SPEED: float = 50.
var _my_room: Level_Room
var _is_moving: bool = true


func _ready() -> void:
	print("MONSTER READY")
	%Area2D.body_entered.connect(_on_body_entered)
	%AnimatedSprite2D.play("run")
	Manage_Room.ref.reset_room.connect(_on_reset_room)
	
	
func _physics_process(delta: float) -> void:
	if _is_moving:
		global_position.x = move_toward(global_position.x,Player.ref.global_position.x,delta * SPEED)
	if Player.ref.global_position < global_position:
		%AnimatedSprite2D.flip_h = false
	else:
		%AnimatedSprite2D.flip_h = true

func assign_room_to_monster(which: Level_Room) -> void:
	_my_room = which
	_my_room.set_visited_by_monster()
	_my_room.update_monster_havingness(true)
	

func move_to_spawn_pos(
pos_override:Vector2=Vector2.ZERO
) -> void:
	var spawn_x_pos: float = \
		Manage_Room.ref.get_monster_spawn_x_pos()
	var spawn_pos: Vector2 = Vector2(spawn_x_pos,0)
	if pos_override == Vector2.ZERO:
		print("Monster thinks current camera zone is ",
			Camera_Zones.ZONES.find_key(Camera_Zones.ref.get_current_zone()))
		match Camera_Zones.ref.get_current_zone():
			Camera_Zones.ZONES.LEFT:
				spawn_pos.x = spawn_x_pos
			Camera_Zones.ZONES.RIGHT:
				spawn_pos.x = -spawn_x_pos
			Camera_Zones.ZONES.MID:
				if Player.ref.global_position.x > 0:
					spawn_pos.x = -spawn_x_pos
				else:
					spawn_pos.x = spawn_x_pos
	else:
		print("POS OVERRIDE DETECTED AS ",pos_override)
		spawn_pos = pos_override
	global_position = spawn_pos
	#print("MONSTER IS AT ",global_position)
			
func _on_body_entered(body:PhysicsBody2D) -> void:
	if body is Player:
		await get_tree().process_frame
		if Manage_RobotParts.ref.all_parts_are_collected():
			Cursor.ref.set_active(false)
			_is_moving = false
			Player.ref.override_movement(true)
			await get_tree().create_timer(2).timeout
			Player.ref.defeat_monster()
			await get_tree().create_timer(3).timeout
			var death: Monster_Death = %Death_Node2D
			_z_on_top(true)
			death.die()
			Player.ref.hide()
			await get_tree().create_timer(2).timeout
			Manage_Game.ref.change_game_state(
				Manage_Game.GAME_STATES.GAME_WIN)
			
			return
		Manage_Game.ref.change_game_state(
			Manage_Game.GAME_STATES.GAME_OVER)

func _on_reset_room(_which_room:Level_Room) -> void:
	_my_room.update_monster_havingness(false)
	_my_room = null
	queue_free()
	
func _z_on_top(indeed:bool) -> void:
	z_index = \
		4096 if indeed else 0
