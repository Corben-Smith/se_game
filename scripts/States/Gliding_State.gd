extends State
class_name Gliding_State

@export var player: CharacterBody2D
var gliding: bool = false

@export var particles: GPUParticles2D

var fly_timer = 0.0
@export var max_fly_timer = 500000.0

func _ready() -> void:
	fly_timer = max_fly_timer
	if !player:
		player = get_parent().get_parent()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		emit_signal("transition", self, "Attack_State", {})

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_horizontal_movement()
	gliding = true 

	if !Input.is_action_pressed("Fire"):
		gliding = false

	if player.is_on_floor():
		gliding = false

	if fly_timer <= 0.0:
		gliding = false

	if gliding:
		fly_timer -= delta
		if player.velocity.y > 30:
			player.velocity.y = 30
	else:
		emit_signal("transition", self, "Falling_State", {})
		return


func handle_horizontal_movement():
	var direction := Input.get_axis("Left", "Right")

	if direction != 0:
			player.velocity.x = move_toward(player.velocity.x, direction * player.stats["max_speed"], player.stats["in_air_acceleration"])
	else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.stats["in_air_deacceleration"])

func enter(previous_state_path: String, data := {}) -> void:
	print("Enter glide")
	fly_timer = max_fly_timer
	gliding = true
	if particles:
		particles.emitting = true

func exit() -> void:
	if particles:
		particles.emitting = false
	pass
