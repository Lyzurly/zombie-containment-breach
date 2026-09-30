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
	if _last_room.was_visited_by_monster():
		return
	var monster: Monster = \
		_MONSTER.instantiate() as Monster
	_last_room.add_child(monster)
	_last_room.set_visited_by_monster()
	monster.move_to_spawn_pos(pos_override)

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
	
	_spawn_monster_if_needed()

func _spawn_monster_if_needed() -> void:
	var spawn_x_pos: float = \
		Manage_Room.ref.get_monster_spawn_x_pos()
	match _last_room.name:
		"Room2":
			print("ROOM 2 BABY")
			spawn_monster(
				Vector2(
				-spawn_x_pos-200,0)
			)	
	
func _activate_room(room:Level_Room,indeed:bool) -> void:
	room.visible = indeed
	room.set_active(indeed)
	room.process_mode = \
		Node.PROCESS_MODE_INHERIT if indeed else PROCESS_MODE_DISABLED
