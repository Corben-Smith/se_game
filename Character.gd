extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var jumpVelocity:float = 0.0
var jumpTimer:float = 0.0
var direction = 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Fire") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if (Input.is_action_just_pressed("ui_up")):
		jumpVelocity = -600 - abs(direction / 3)
		
	if (Input.is_action_pressed("ui_up") && jumpTimer < 0.25):
		velocity.y = jumpVelocity
		jumpTimer += delta
	
	if (!Input.is_action_pressed("ui_up") && is_on_floor()):
		jumpTimer = 0.0
		jumpVelocity = 0.0
	
	if (!is_on_floor()):
		velocity.y += 40
	move_and_slide()
