class_name Monster extends Node2D
static var ref: Monster
func _init() -> void:
	ref = self
	
const SPEED: float = 50.

func _ready() -> void:
	%Area2D.body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	global_position.x = move_toward(global_position.x,Player.ref.global_position.x,delta * SPEED)
	if Player.ref.global_position < global_position:
		%AnimatedSprite2D.flip_h = true
	else:
		%AnimatedSprite2D.flip_h = false

func _on_body_entered(body:PhysicsBody2D) -> void:
	if body is Player:
		await get_tree().process_frame
		get_tree().reload_current_scene()
