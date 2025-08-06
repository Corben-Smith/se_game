extends Node2D 

enum DIRECTION { LEFT, RIGHT, UP, DOWN }

@export var direction: DIRECTION

var particles: GPUParticles2D

func _ready() -> void:
	ready_particle()
	

func ready_particle():
	particles = get_node_or_null("GPUParticles2D")
	if particles == null:
		print("nopart")
		return
	
	match direction:
		DIRECTION.LEFT:
			particles.rotation_degrees = -90
		DIRECTION.RIGHT:
			particles.rotation_degrees = 90
		DIRECTION.UP:
			particles.rotation_degrees = 0
		DIRECTION.DOWN:
			particles.rotation_degrees = 180

func explode():
	particles.emitting = true

func get_dir() -> Vector2:
	return direction_to_vector(direction)

func direction_to_vector(dir: DIRECTION) -> Vector2:
	match dir:
		DIRECTION.UP:
			return Vector2.UP
		DIRECTION.RIGHT:
			return Vector2.RIGHT
		DIRECTION.DOWN:
			return Vector2.DOWN
		DIRECTION.LEFT:
			return Vector2.LEFT
		_:
			return Vector2.ZERO
