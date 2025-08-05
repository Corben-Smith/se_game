extends State
class_name Isaiah_Running
@export var player: CharacterBody2D

var previous_direction := 0
@export var animation_sprite: AnimatedSprite2D

@export var boost_amount := 150.0
@export var particles: GPUParticles2D = null

func enter(previous_state_path: String, data := {}) -> void:
	previous_direction = sign(owner.velocity.x)
	animation_sprite.play("Running")

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()

	if !particles:
		return

	if !animation_sprite:
		animation_sprite = player.get_node("Sprite2D")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		emit_signal("transition", self, "Jumping_State", {})
	elif event.is_action_pressed("Light_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "light"})
	elif event.is_action_pressed("Medium_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "medium"})
	elif event.is_action_pressed("Heavy_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "heavy"})

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:

	var current_direction = sign(player.velocity.x)

	if not player.is_on_floor():
		emit_signal("transition", self, "Falling_State", {})

	if player.velocity.x == 0:
		emit_signal("transition", self, "Idle_State", {})

	handle_horizontal_movement()


func handle_horizontal_movement():
	var direction := Input.get_axis("Left", "Right")
	
	if direction < 0:
		player.sprite.flip_h = true
		# Also flip damage area
		player.deal_damage_area.scale.x = -1
	elif direction > 0:
		player.sprite.flip_h = false
		# Also flip damage area
		player.deal_damage_area.scale.x = 1

	# Handle boost particles and velocity boost
	if direction != 0:
		if sign(direction) != sign(player.velocity.x):
			if particles:
				particles.restart()
			# Apply boost
			player.velocity.x += boost_amount * direction 
		
		# Apply normal movement
		player.velocity.x = move_toward(player.velocity.x, direction * player.stats["max_speed"], player.stats["acceleration"])
	else:
		# Decelerate when no input
		player.velocity.x = move_toward(player.velocity.x, 0, player.stats["deacceleration"])

func exit() -> void:
	pass
