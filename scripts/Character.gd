extends CharacterBody2D
class_name Player

# Movement variables
@export var acceleration: float = 50.0
@export var deacceleration: float = 100.0
@export var max_speed: float = 300.0

@export var in_air_acceleration: float = 20.0
@export var in_air_deacceleration: float = 20.0
@export var jump_force: float = -450.0
@export var gravity: float = 1000.0
@export var falling_gravity: float = 2000.0
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


@export var state_machine: StateMachine = null
func _ready() -> void:
    if !state_machine:
        state_machine = $StateMachine

func _physics_process(delta: float) -> void:
    line.add_point(global_position)  # Add point to the line
    if Input.is_action_just_pressed("Alt_Fire"):
        line.clear_points()

    if is_on_floor():
        coyote_timer = coyote_time
    else:
        coyote_timer -= delta

    print(state_machine.current_state)
    move_and_slide()

func _input(event: InputEvent) -> void:
    state_machine.handle_input(event)

func _unhandled_input(event: InputEvent) -> void:
    state_machine.handle_input(event)

func apply_gravity(delta):
    if not is_on_floor():
        if velocity.y > 0:
            velocity.y += falling_gravity * delta  # Stronger gravity when falling
        else:
            velocity.y += gravity * delta         # Normal gravity when rising
    else:
        velocity.y = 0  # Reset vertical velocity when on the floor


func handle_horizontal_movement():
    var direction := Input.get_axis("Left", "Right")

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

func handle_jumping(delta):

    if Input.is_action_just_pressed("Fire"):
        jump_buffer_timer = jump_buffer_time
    else:
        jump_buffer_timer -= delta

    if (is_on_floor() or coyote_timer > 0) and jump_buffer_timer > 0:
        velocity.y = jump_force
        is_jumping = true
        jump_buffer_timer = 0  # Reset jump buffer

    if Input.is_action_just_released("Fire") and velocity.y < 0:
        velocity.y *= variable_jump_multiplier
        is_jumping = false
