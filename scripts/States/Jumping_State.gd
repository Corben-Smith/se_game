extends State
class_name Jumping_State

@export var player: CharacterBody2D

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("Fire") and player.velocity.y < 0:
		player.velocity.y *= player.stats["variable_jump_multiplier"]
	elif event.is_action_pressed("Attack"):
		emit_signal("transition", self, "Attack_State", {})

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_horizontal_movement()
	if player.velocity.y > 0:
		player.velocity.y += player.stats["falling_gravity"] * delta
	else:
		player.velocity.y += player.stats["gravity"] * delta


	if player.velocity.y > 0:
		emit_signal("transition", self, "Falling_State", {})

func handle_horizontal_movement():
	var direction := Input.get_axis("Left", "Right")

	if direction != 0:
			player.velocity.x = move_toward(player.velocity.x, direction * player.stats["max_speed"], player.stats["in_air_acceleration"])
	else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.stats["in_air_deacceleration"])

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.stats["jump_force"]

func exit() -> void:
	pass
