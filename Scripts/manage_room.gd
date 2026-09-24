class_name Manage_Room extends Node
static var ref: Manage_Room
func _init() -> void:
	ref = self

signal door_opened(which_door: Door, id:int)
signal reset_room(which_room: Level_Room)

const _MONSTER: PackedScene = preload("uid://dgsxvuatjaxvo")

var _last_room: Level_Room
var _next_room: Level_Room
	
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

func spawn_monster() -> void:
	if not _last_room:
		push_error("NO MONSTA IF NO ROOM HAHA")
		return
		
	var monster: Monster = \
		_MONSTER.instantiate() as Monster
	_last_room.add_child(monster)
	monster.move_to_spawn_pos()

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
	
func _activate_room(room:Level_Room,indeed:bool) -> void:
	room.visible = indeed
	room.set_active(indeed)
	room.process_mode = \
		Node.PROCESS_MODE_INHERIT if indeed else PROCESS_MODE_DISABLED
