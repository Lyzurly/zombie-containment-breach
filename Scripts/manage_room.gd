class_name Manage_Room extends Node
static var ref: Manage_Room
func _init() -> void:
	ref = self

signal door_opened(which_door: Door, id:int)
signal reset_room(which_room: Level_Room)

const _MONSTER: PackedScene = preload("uid://dgsxvuatjaxvo")
#const _ROBOT_PART: PackedScene = preload("uid://bn67j63304rcp")
const _SPAWN_X_POS: float = 700.


var _last_room: Level_Room
var _next_room: Level_Room

var _last_door: Clickable

	
func _ready() -> void:
	Level.ref.level_faded.connect(_on_level_faded)

func set_first_last_room(to:Level_Room) -> void:
	_last_room = to
	
func change_room(
by_what:Clickable,
to_where:Level_Room,
indeed:bool
) -> void:
	_next_room = to_where
	Level.ref.darken(by_what,indeed)
	if indeed:
		pass
		
func set_last_door(which_door:Clickable) -> void:
	_last_door = which_door
func get_last_door(error_override:bool=false) -> Clickable:
	if not _last_door and not error_override:
		push_error(
			"ASKIN FOR A DOOR THAT AINT THERE GIRL")
	return _last_door
	
func force_reset_room() -> void:
	reset_room.emit(_last_room)

func spawn_monster(
pos_override:Vector2=Vector2.ZERO
) -> void:
	if not _last_room:
		push_error("NO MONSTA IF NO ROOM HAHA")
		return
	if _last_room.does_have_monster():
		return
	if _last_room.was_visited_by_monster() \
	and not Manage_RobotParts.ref.all_parts_are_collected():
		_last_room.reduce_monster_likelihood()
		if not _roll_monster(_last_room):
			return
		pos_override = Vector2(Vector2.ZERO)
		print("MONSTER ROLLED!")
	var monster: Monster = \
		_MONSTER.instantiate() as Monster
	_last_room.add_child(monster)
	monster.assign_room_to_monster(_last_room)
	monster.move_to_spawn_pos(pos_override)
	
func _roll_monster(to_what_room:Level_Room) -> bool:
	var floor: float = \
		to_what_room.get_monster_likelihood_floor()
	var roll: float = randf_range(
		floor,1)
	return roll > 0

#func spawn_robot_part(at_what:Clickable) -> void:
	#if not _last_room:
		#push_error("NO ROBOT PART IF NO ROOM HAHA")
		#return
		#
	#var spawners: Array[Clickable] = \
		#Manage_RobotParts.ref.get_spawners()
	#if not spawners.has(at_what):
		#print("NOT spawning at ",at_what.name,"...")
		#return
		#
	#print("Spawning at ",at_what.name,"...")
	#
	#var part: Player_RobotPart = \
		#_ROBOT_PART.instantiate()
	#_last_room.add_child(part)
	#
	#var spawn_pos: Vector2 = at_what.global_position
	#part.global_position = spawn_pos

func get_monster_spawn_x_pos() -> float:
	return _SPAWN_X_POS	

func _on_level_faded() -> void:
	if not _next_room:
		push_error(
			"UM WHER DA ROOM"
		)
	
	reset_room.emit(_last_room)
	
	_activate_room(_last_room,false)
	_activate_room(_next_room,true)
	
	_last_room = _next_room 
	_next_room = null

func spawn_monster_if_needed() -> void:
	var spawn_x_pos: float = \
		Manage_Room.ref.get_monster_spawn_x_pos()
	match _last_room.name:
		"Room2":
			spawn_monster(
				Vector2(
				-spawn_x_pos-200,0)
			)	
		"Room4":
			spawn_monster(
				Vector2(
				-spawn_x_pos,0)
			)	
		"Room5":
			var roll: float = randf_range(-1,1)
			var polarity: float = \
				-1 if roll < 0 else 1
			spawn_monster(
				Vector2(
				polarity*spawn_x_pos,0)
			)
	
func _activate_room(room:Level_Room,indeed:bool) -> void:
	room.visible = indeed
	room.set_active(indeed)
	room.process_mode = \
		Node.PROCESS_MODE_INHERIT if indeed else PROCESS_MODE_DISABLED
