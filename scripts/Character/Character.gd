extends CharacterBody2D
class_name Player

@onready var deal_damage_area = $DealDamageArea
@onready var sprite: AnimatedSprite2D = $Sprite2D  

signal died

# Internal variables
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_jumping: bool = false
var is_attacking: bool = false

var direction: Vector2 = Vector2.RIGHT

@export var stats: PlayerStats = null
@export var state_machine: StateMachine = null
@export var status_manager: StatusEffectManager = null
@export var health_component: HealthComponent = null
@export var attack_damage: int = 10
@onready var label: Label = $Label

var base_scale 
var left_scale
var right_scale

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
	# Disable damage area at the start
	deal_damage_area.monitoring = false
	$DealDamageArea/CollisionShape2D.disabled = true
	
	# Connect damage signal
	deal_damage_area.connect("body_entered", _on_deal_damage_area_body_entered)

	health_component.health_depleted.connect(handle_death)

	base_scale = abs(self.scale.x)
	left_scale = -base_scale
	right_scale = base_scale

func handle_death():
	died.emit()


func _physics_process(delta: float) -> void:
	if label:
		label.text = state_machine.current_state.name
	if is_on_floor():
		coyote_timer = stats["coyote_time"]
	else:
		coyote_timer -= delta

	move_and_slide()
	if velocity.x != Vector2.ZERO.x:
		direction = Vector2(velocity.x, velocity.y).normalized()

func _input(event: InputEvent) -> void:
	state_machine.handle_input(event)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func apply_gravity(delta):
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += stats["falling_gravity"] * delta
		else:
			velocity.y += stats["gravity"] * delta
		
		# Limit maximum falling speed
		velocity.y = min(velocity.y, stats["max_falling_speed"])
	else:
		velocity.y = 0


func handle_horizontal_movement():
	var input_direction := Input.get_axis("Left", "Right")

	if input_direction < 0:
		sprite.flip_h = true
		# Also flip damage area
		deal_damage_area.scale.x = -1
	elif input_direction > 0:
		sprite.flip_h = false
		# Also flip damage area
		deal_damage_area.scale.x = 1

	if is_on_floor():
		if input_direction != 0:
			velocity.x = move_toward(velocity.x, input_direction * stats["max_speed"], stats["acceleration"])
		else:
			velocity.x = move_toward(velocity.x, 0, stats["deacceleration"])
	else:
		if input_direction != 0:
			velocity.x = move_toward(velocity.x, input_direction * stats["max_speed"], stats["in_air_acceleration"])
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
		jump_buffer_timer = 0

	if Input.is_action_just_released("Fire") and velocity.y < 0:
		velocity.y *= stats["variable_jump_multiplier"]
		is_jumping = false

func toggle_flip_damage(dir):
	if dir > 1:
		deal_damage_area.scale.x = 1
	elif dir < -1:
		deal_damage_area.scale.x = -1

func _on_deal_damage_area_body_entered(body):
	if is_attacking and body.has_method("take_damage"):
		body.take_damage(attack_damage)
