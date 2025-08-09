extends State 
class_name Isaiah_Idle

@export var player: CharacterBody2D
@export var animation_sprite: AnimatedSprite2D

func _ready() -> void:
	if !player:
		player = get_parent().parent

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

func update(delta: float) -> void:
	pass

var first_frame = true
func physics_update(delta: float) -> void:
	# Handle horizontal movement

	var direction := Input.get_axis("Left", "Right")
	if direction != 0:
		emit_signal("transition", self, "Running_State", {})

	# Apply gravity
	if not player.is_on_floor():
		print("not on floor")
		emit_signal("transition", self, "Falling_State", {})

	if player.velocity.x != 0 && !first_frame:
		player.velocity.x = move_toward(player.velocity.x, 0, player.stats["deacceleration"])
	first_frame = false

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = 0
	first_frame = true
	animation_sprite.play("Idle")

func exit() -> void:
	pass
