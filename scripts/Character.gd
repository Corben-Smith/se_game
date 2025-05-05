extends CharacterBody2D
class_name Player

@onready var deal_damage_area = $DealDamageArea
@onready var sprite = $Sprite2D #this ill be used for making character flash red
# Internal variables
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_jumping: bool = false
var is_attacking: bool = false

@export var stats: PlayerStats = null
@export var state_machine: StateMachine = null
@export var status_manager: StatusEffectManager = null
@export var health_component: HealthComponent = null
@export var attack_damage: int = 25

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
	if event.is_action_pressed("test_damage"):
		take_damage()


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
	var direction := Input.get_axis("Left", "Right")

	if direction != 0:
		toggle_flip_damage(direction)

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
		jump_buffer_timer = 0

	if Input.is_action_just_released("Fire") and velocity.y < 0:
		velocity.y *= stats["variable_jump_multiplier"]
		is_jumping = false

func toggle_flip_damage(dir):
	if dir == 1:
		deal_damage_area.scale.x = 1
	elif dir == -1:
		deal_damage_area.scale.x = -1

func _on_deal_damage_area_body_entered(body):
	print("👀 Entered DealDamageArea. Collided with: ", body.name)

	if is_attacking:
		print("✅ Player is attacking.")

	if body.is_in_group("enemy"):
		print("🎯 Body is in enemy group.")

	if body.has_method("take_damage"):
		print("🛠️ Body has take_damage method.")

	if is_attacking and body.is_in_group("enemy") and body.has_method("take_damage"):
		print("🗡️ Hit enemy!")
		body.take_damage(attack_damage)

func take_damage(amount: int = 1):
	print("🩸 Player take_damage() called with amount:", amount)
	if health_component:
		print("✅ health_component exists. Calling take_damage...")
		health_component.take_damage(amount)
		flash_red()
	else:
		print("❌ health_component is null")

func flash_red():
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
