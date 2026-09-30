class_name Level_Room extends TileMapLayer

var _active: bool = false

var _visited_by_monster: bool = false

func _ready() -> void:
	if name == "Room1":
		_ready_first_room()
	Manage_Room.ref.reset_room.connect(_on_reset_room)

func _ready_first_room() -> void:
	print("ROOM READY")
	_active = true
	Manage_Room.ref.set_first_last_room(self)
	
	await get_tree().process_frame
	Manage_Room.ref.spawn_monster()

func set_active(indeed:bool) -> void:
	_active = indeed
	
func is_active() -> bool:
	return _active

func set_visited_by_monster() -> void:
	_visited_by_monster = true
func was_visited_by_monster() -> bool:
	return _visited_by_monster

func _on_reset_room(which_room:Level_Room) -> void:
	if not self == which_room:
		return
	for child in get_children():
		if child is Room_Object:
			var room: Room_Object = child as Room_Object
			room.reset()
