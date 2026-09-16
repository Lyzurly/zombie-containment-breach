@abstract class_name Clickable extends Node2D

@abstract func _my_sprite() -> Sprite2D
@abstract func _on_click(
clicks:int,while_holding:HOLDABLES
) -> void

enum HOLDABLES{
	NOTHING,KEY1
	}

var _click_count: int = 0
var _hovered: bool = false

func _ready() -> void:
	Cursor.ref.clickable_hovered.connect(_on_clickable_hovered)
	
func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = \
		get_local_mouse_position()
	
	var sprite_rect: Rect2 = _my_sprite().get_rect()
	#print(self," has the sprite ",_my_sprite)
	if sprite_rect.has_point(mouse_pos):
		#print("HOVERING ",self," with sprite ",_my_sprite," with rect ",sprite_rect,
		 #" with transform ",_my_sprite().transform)
		_hovered = true
		Cursor.ref.change_cursor_state(
			Cursor.CURSOR_STATES.HOVERING_CLICKABLE
			)
	else:
		if _hovered:
			Cursor.ref.change_cursor_state(
				Cursor.CURSOR_STATES.NONE
				)
			_hovered = false
		

func click(while_holding:HOLDABLES) -> void:
	_click_count += 1
	_on_click(_click_count,while_holding)


func _on_clickable_hovered() -> void:
	#print(self," knows something was hovered...")
	if _hovered:
		Cursor.ref.set_hovered_clickable(self)
	#else:
		#print(self," was not hovered...")
