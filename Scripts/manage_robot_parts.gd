class_name Manage_RobotParts extends Node
static var ref: Manage_RobotParts
func _init() -> void:
	ref = self

signal collected_part(which_part:Player_RobotPart.PARTS)
signal collected_all_parts()
	
var _all_parts_collected: bool = false
var _spawners: Array[Clickable] = []
var _collected_parts: Array[Player_RobotPart.PARTS] = []

func _ready() -> void:
	_ready_spawners()

func _ready_spawners() -> void:
	var spawners: Array[Clickable] = []
	var cheesed_spawners: Array[Clickable] = []
	spawners.assign(_spawners)
	for spawner in spawners:
		if spawner.name == "Clickable_Box18":
			cheesed_spawners.append(spawner)
			spawners.erase(spawner)
			break
	for spawner in spawners:
		if spawner.name == "Clickable_Box19":
			cheesed_spawners.append(spawner)
			spawners.erase(spawner)
			break
	spawners.shuffle()
	for cheesed_spawner in cheesed_spawners:
		spawners.push_front(cheesed_spawner)
	spawners.resize(5)
	_spawners.assign(spawners)
	print("LOGGING SPAWNERS:\n\t",_spawners)

func init_log_spawner(which:Clickable) -> void:
	print("LOGGING SPAWNER:\n\t",which)
	_spawners.append(which)
	
func set_all_parts_collected () -> void:
	_all_parts_collected = true
func all_parts_are_collected() -> bool:
	return _all_parts_collected

func collect_a_part(who_collected:Clickable) -> void:
	if not _spawners.has(who_collected):
		return
	var parts: Array[Player_RobotPart.PARTS] = [
	]
	parts.assign(Player_RobotPart.PARTS.values())
	parts.shuffle()
	for part in parts:
		if part == Player_RobotPart.PARTS.NULL:
			continue
		if _collected_parts.has(part):
			continue
		_collected_parts.append(part)
		print("COLLECTING a ",Player_RobotPart.PARTS.find_key(part))
		collected_part.emit(part)
		
		if _collected_parts.size() == 5:
			collected_all_parts.emit()
		break
