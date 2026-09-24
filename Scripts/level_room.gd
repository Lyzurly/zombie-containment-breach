class_name Level_Room extends TileMapLayer

const _MONSTER: PackedScene = preload("uid://dgsxvuatjaxvo")

var _active: bool = false

func _ready() -> void:
	if name == "Room1":
		_ready_first_room()
	
	Manage_Room.ref.reset_room.connect(_on_reset_room)

func _ready_first_room() -> void:
	_active = true
	Manage_Room.ref.set_first_last_room(self)
	
func spawn_monster() -> void:
	var monster: Monster = \
		_MONSTER.instantiate() as Monster
	add_child(monster)

func set_active(indeed:bool) -> void:
	_active = indeed
	
func is_active() -> bool:
	return _active

func _on_reset_room(which_room:Level_Room) -> void:
	if not self == which_room:
		return
	for child in get_children():
		if child is Room_Object:
			var room: Room_Object = child as Room_Object
			room.reset()
