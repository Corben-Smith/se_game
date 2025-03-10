extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Remove jump and movement logic
	# This ensures "Character" no longer moves.

	move_and_slide()
