extends CharacterBody2D
@export var lift_height: float = 100
@export var move_speed: float = 50
@export var wait_time: float = 2.0

@onready var trigger = $TriggerZone

var start_position: Vector2
var end_position: Vector2

var is_moving_up: bool = false
var is_moving_down: bool = false
var triggered: bool = false

func _ready() -> void:
	start_position = global_position
	end_position = start_position + Vector2(0, -lift_height)
	trigger.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if is_moving_up:
		global_position = global_position.move_toward(end_position, move_speed * delta)
		if global_position.distance_to(end_position) < 1:
			is_moving_up = false
			await get_tree().create_timer(wait_time).timeout
			is_moving_down = true

	elif is_moving_down:
		global_position = global_position.move_toward(start_position, move_speed * delta)
		if global_position.distance_to(start_position) < 1:
			is_moving_down = false
			triggered = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		is_moving_up = true
