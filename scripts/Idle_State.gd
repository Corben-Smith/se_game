extends State 
class_name Idle_State

@export var player: CharacterBody2D

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		emit_signal("transition", self, "Jumping_State", {})

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Handle horizontal movement
	var direction := Input.get_axis("Left", "Right")
	if direction != 0:
		emit_signal("transition", self, "Running_State", {})

	# Apply gravity
	if not player.is_on_floor():
		emit_signal("transition", self, "Falling_State", {})

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0

func exit() -> void:
	pass
