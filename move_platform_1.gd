extends Node2D
@export var move_distance: float = 200.0
@export var move_speed: float = 100.0
@export var move_direction: Vector2 = Vector2.RIGHT

var start_position: Vector2
var target_position: Vector2
var moving_forward: bool = true

func _ready():
	start_position = global_position
	target_position = start_position + (move_direction.normalized() * move_distance)

func _process(delta):
	var direction = (target_position - global_position).normalized()
	global_position += direction * move_speed * delta
	
	if moving_forward and global_position.distance_to(target_position) < 5.0:
		moving_forward = false
		target_position = start_position
	elif not moving_forward and global_position.distance_to(start_position) < 5.0:
		moving_forward = true
		target_position = start_position + (move_direction.normalized() * move_distance)
