extends CharacterBody2D
class_name Player


# Internal variables
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_jumping: bool = false

@export var stats: PlayerStats = null
@export var state_machine: StateMachine = null
@export var status_manager: StatusEffectManager = null
@export var health_component: HealthComponent = null

func _ready() -> void:
    add_to_group("player")
    if !stats:
        push_error("please specify a player stats obj in the inspector")
    if !state_machine:
        state_machine = $StateMachine
    if !status_manager:
        status_manager = $StatusEffectManager
    if !health_component:
        health_component = $HealthComponent

func _physics_process(delta: float) -> void:
    if is_on_floor():
        coyote_timer = stats["coyote_time"]
    else:
        coyote_timer -= delta

    if velocity.x < 0:
        $Sprite2D.flip_h = true
    elif velocity.x > 0:
        $Sprite2D.flip_h = false


    move_and_slide()


func _input(event: InputEvent) -> void:
    state_machine.handle_input(event)

func _unhandled_input(event: InputEvent) -> void:
    state_machine.handle_input(event)

func apply_gravity(delta):
    if not is_on_floor():
        if velocity.y > 0:
            velocity.y += stats["falling_gravity"] * delta  # Stronger gravity when falling
        else:
            velocity.y += stats["gravity"] * delta         # Normal gravity when rising
    else:
        velocity.y = 0  # Reset vertical velocity when on the floor


func handle_horizontal_movement():
    var direction := Input.get_axis("Left", "Right")

    if is_on_floor():
        if direction != 0:
                velocity.x = move_toward(velocity.x, direction * stats["max_speed"], stats["acceleration"])
        else:
                velocity.x = move_toward(velocity.x, 0, stats["deacceleration"])
    else:
        if direction != 0:
                velocity.x = move_toward(velocity.x, direction * stats["max_speed"], stats["in_air_acceleration"])
        else:
                velocity.x = move_toward(velocity.x, 0, stats["in_air_deacceleration"])

func handle_jumping(delta):
    if Input.is_action_just_pressed("Fire"):
        jump_buffer_timer = stats["jump_buffer_time"]
    else:
        jump_buffer_timer -= delta

    if (is_on_floor() or coyote_timer > 0) and jump_buffer_timer > 0:
        velocity.y = stats["jump_force"]
        is_jumping = true
        jump_buffer_timer = 0  # Reset jump buffer

    if Input.is_action_just_released("Fire") and velocity.y < 0:
        velocity.y *= stats["variable_jump_multiplier"]
        is_jumping = false







