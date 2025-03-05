extends CharacterBody2D

# Movement variables
@export var acceleration: float = 50.0
@export var deacceleration: float = 75.0
@export var in_air_acceleration: float = 20.0
@export var in_air_deacceleration: float = 20.0
@export var max_speed: float = 300.0
@export var jump_force: float = -300.0
@export var gravity: float = 800.0
@export var falling_gravity: float = 3000.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var variable_jump_multiplier: float = 0.5  # For variable jump height

# Internal variables
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_jumping: bool = false

@export var max_jump_points: int = 30  # Number of points to draw in the arc
@export var point_spacing: float = 10.0  # Horizontal spacing between points

@onready var line: Line2D = $Line2D  # Reference to the Line2D node

func _ready():
	update_jump_arc()

func update_jump_arc():
	line.clear_points()  # Clear previous points


func _physics_process(delta: float) -> void:
	line.add_point(global_position)  # Add point to the line

	print(is_on_floor())
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += falling_gravity * delta  # Stronger gravity when falling
		else:
			velocity.y += gravity * delta         # Normal gravity when rising
	else:
		velocity.y = 0  # Reset vertical velocity when on the floor

	# Handle horizontal movement
	var direction := Input.get_axis("Left", "Right")

	if Input.is_action_just_pressed("Alt_Fire"):
		line.clear_points()

	if is_on_floor():
		if direction != 0:
				velocity.x = move_toward(velocity.x, direction * max_speed, acceleration)
		else:
				velocity.x = move_toward(velocity.x, 0, deacceleration)
	else:
		if direction != 0:
				velocity.x = move_toward(velocity.x, direction * max_speed, in_air_acceleration)
		else:
				velocity.x = move_toward(velocity.x, 0, in_air_deacceleration)



	# Coyote time logic
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Jump buffering logic
	if Input.is_action_just_pressed("Fire"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# Handle jumping
	if (is_on_floor() or coyote_timer > 0) and jump_buffer_timer > 0:
		velocity.y = jump_force
		is_jumping = true
		jump_buffer_timer = 0  # Reset jump buffer

	# Variable jump height (cut jump short if button is released)
	if Input.is_action_just_released("Fire") and velocity.y < 0:
		velocity.y *= variable_jump_multiplier
		is_jumping = false

	# Move the character
	move_and_slide()
