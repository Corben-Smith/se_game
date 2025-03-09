extends State
class_name Falling_State 

@export var player: CharacterBody2D

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		emit_signal("transition", self, "Jumping_State", {})

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		emit_signal("transition", self, "Idle_State", {})
	player.velocity.y += player.falling_gravity * delta  # Stronger gravity when falling


func enter(previous_state_path: String, data := {}) -> void:
	pass

func exit() -> void:
	pass
