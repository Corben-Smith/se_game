extends State


@export var player: CharacterBody2D

var previous_direction := 0

@export var boost_amount := 150.0
@export var particles: GPUParticles2D = null

func enter(previous_state_path: String, data := {}) -> void:
	previous_direction = sign(owner.velocity.x)

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()

	if !particles:
		return

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		emit_signal("transition", self, "Jumping_State", {})
	elif event.is_action_pressed("Attack"):
		emit_signal("transition", self, "Attack_State", {})
	elif event.is_action_pressed("Shoot"):
		emit_signal("transition", self, "Shooting_State", {})

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	handle_horizontal_movement()

	var current_direction = sign(player.velocity.x)


	if not player.is_on_floor():
		emit_signal("transition", self, "Falling_State", {})

	if player.velocity.x == 0:
		emit_signal("transition", self, "Idle_State", {})

func handle_horizontal_movement():
	var direction := Input.get_axis("Left", "Right")


	if direction != 0:
		if sign(direction) != sign(player.velocity.x):
			if particles:
				particles.restart()

			# Apply boost
			player.velocity.x += boost_amount * direction 

		player.velocity.x = move_toward(player.velocity.x, direction * player.stats["max_speed"], player.stats["acceleration"])
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.stats["deacceleration"])

func exit() -> void:
	pass
