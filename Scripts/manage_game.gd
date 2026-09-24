class_name Manage_Game extends Node
static var ref: Manage_Game
func _init() -> void:
	ref = self
	
var _game_state: GAME_STATES = GAME_STATES.NONE
enum GAME_STATES{
	NONE,CINEMATIC,GAMEPLAY
	}
	
func _ready() -> void:
	pass
	
func is_state(which:GAME_STATES) -> bool:
	return which == _game_state

func change_game_state(to:GAME_STATES) -> void:
	if _game_state == to:
		return
		
	var change_approved: bool = false
	
	match to:
		GAME_STATES.NONE:
			change_approved = _check_none()
		GAME_STATES.CINEMATIC:
			change_approved = _check_cinematic()
		GAME_STATES.GAMEPLAY:
			change_approved = _check_gameplay()
		
	if change_approved:
		match to:
			GAME_STATES.NONE:
				_on_none()
			GAME_STATES.CINEMATIC:
				_on_cinematic()
			GAME_STATES.GAMEPLAY:
				_on_gameplay()
		_game_state = to
	else:
		return
		
func _check_none() -> bool:
	return true
func _on_none() -> void:
	pass
	
func _check_cinematic() -> bool:
	return true
func _on_cinematic() -> void:
	pass
	
func _check_gameplay() -> bool:
	return true
func _on_gameplay() -> void:
	Level.ref.add_player()
		
