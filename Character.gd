extends CharacterBody2D

# Movement variables
@export var acceleration: float = 50.0
@export var deacceleration: float = 75.0
@export var max_speed: float = 300.0
@export var jump_force: float = -300.0
@export var gravity: float = 800.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var variable_jump_multiplier: float = 0.5  # For variable jump height

# Internal variables
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_jumping: bool = false

func _physics_process(delta: float) -> void:
    # Apply gravity
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        velocity.y = 0  # Reset vertical velocity when on the floor

    # Handle horizontal movement
    var direction := Input.get_axis("Left", "Right")
    if direction != 0:
        velocity.x = move_toward(velocity.x, direction * max_speed, acceleration)
    else:
        velocity.x = move_toward(velocity.x, 0, deacceleration)

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
