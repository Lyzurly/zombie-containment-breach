class_name Manage_RobotParts extends Node
static var ref: Manage_RobotParts
func _init() -> void:
	ref = self

enum PARTS{NULL,BODY,LEG_L,LEG_R,ARM_L,ARM_R}
enum PARTS_CONTENT{
	SPAWNED, ## bool
	COLLECTED, ## bool
	TEXTURE, ## CompressedTexture2D
	}
	
const _PART_SCENE: PackedScene = preload("uid://bn67j63304rcp")
		
var _spawners: Array[Clickable] = []
	
var _registry: Dictionary[PARTS,Dictionary] = {
	#PARTS.NULL: {
		#PARTS_CONTENT.SPAWNED: false,
		#PARTS_CONTENT.COLLECTED: false,
	#},
	PARTS.BODY: {
		PARTS_CONTENT.SPAWNED: false,
		PARTS_CONTENT.COLLECTED: false,
		PARTS_CONTENT.TEXTURE: preload("uid://iju1w7dhjn7a"),
	},
	PARTS.LEG_L: {
		PARTS_CONTENT.SPAWNED: false,
		PARTS_CONTENT.COLLECTED: false,
		PARTS_CONTENT.TEXTURE: preload("uid://cjm0ewlq68qxg"),
	},
	PARTS.LEG_R: {
		PARTS_CONTENT.SPAWNED: false,
		PARTS_CONTENT.COLLECTED: false,
		PARTS_CONTENT.TEXTURE: preload("uid://cjm0ewlq68qxg"),
	},
	PARTS.ARM_L: {
		PARTS_CONTENT.SPAWNED: false,
		PARTS_CONTENT.COLLECTED: false,
		PARTS_CONTENT.TEXTURE: preload("uid://df1jbh42u1me2"),
	},
	PARTS.ARM_R: {
		PARTS_CONTENT.SPAWNED: false,
		PARTS_CONTENT.COLLECTED: false,
		PARTS_CONTENT.TEXTURE: preload("uid://df1jbh42u1me2"),
	},
}

func _ready() -> void:
	_ready_spawners()

func _ready_spawners() -> void:
	var spawners: Array[Clickable] = []
	spawners.assign(_spawners)
	spawners.shuffle()
	spawners.resize(5)
	_spawners.assign(spawners)
	print("LOGGING SPAWNERS:\n\t",_spawners)

func get_registry() -> Dictionary[PARTS,Dictionary]:
	return _registry
	
func check_registry(
for_which_part:PARTS,
check_what:PARTS_CONTENT
) -> Variant:
	return _registry[for_which_part][check_what]
	
func update_registry(
for_which_part:PARTS,
update_what:PARTS_CONTENT,
to:Variant,
) -> void:
	_registry[for_which_part][update_what] = to

func log_spawner(which:Clickable) -> void:
	print("LOGGING SPAWNER:\n\t",which)
	_spawners.append(which)

func spawn_part(at_what:Clickable) -> void:
	if not _spawners.has(at_what):
		return
	var part: Player_RobotPart = \
		_PART_SCENE.instantiate()
