extends State
class_name Isaiah_Falling
@export var player: Player

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire") && player.coyote_timer > 0:
		emit_signal("transition", self, "Jumping_State", {})
	elif event.is_action_pressed("Light_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "light"})
	elif event.is_action_pressed("Medium_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "medium"})
	elif event.is_action_pressed("Heavy_Attack"):
		emit_signal("transition", self, "Attack_State", {"attack_type": "heavy"})

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		emit_signal("transition", self, "Idle_State", {})
	player.velocity.y += player.stats["falling_gravity"] * delta  # Stronger gravity when fallingfallingD
	player.handle_horizontal_movement()


func enter(previous_state_path: String, data := {}) -> void:
	print(player.velocity.y)
	player.get_node("Sprite2D").play("Falling")

func exit() -> void:
	pass
