extends State
class_name Isaiah_Jumping
@export var player: CharacterBody2D

@export var particles: GPUParticles2D = null

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("Fire") and player.velocity.y < 0:
		player.velocity.y *= player.stats["variable_jump_multiplier"]
	elif event.is_action_pressed("Light_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "light"})
	elif event.is_action_pressed("Medium_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "medium"})
	elif event.is_action_pressed("Heavy_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "heavy"})

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	player.handle_horizontal_movement()
	if player.velocity.y > 0:
		player.velocity.y += player.stats["falling_gravity"] * delta
	else:
		player.velocity.y += player.stats["gravity"] * delta

	if player.velocity.y > 0:
		emit_signal("transition", self, "Falling_State", {})

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.stats["jump_force"]
	particles.restart()

func exit() -> void:
	pass
