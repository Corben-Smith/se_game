extends State
class_name Isaiah_Attack_State

@export var player: CharacterBody2D
@export var attack_hitbox: Area2D
@export var attack_collision: CollisionShape2D
@export var debug: Sprite2D

# Attack properties
var current_attack_type: String = ""
var attack_timer: float = 0.0
var combo_count: int = 0
var max_light_combo: int = 3
var can_combo: bool = false
var combo_window: float = 0.0
var combo_window_duration: float = 0.2

# Attack data
var attack_data = {
	"light": {
		"damage": 10,
		"duration": 0.3,
		"combo_window": 0.3,
		"knockback": 100,
		"can_chain_to": ["light", "medium", "heavy"]
	},
	"medium": {
		"damage": 25,
		"duration": 0.5,
		"combo_window": 0.5,
		"knockback": 200,
		"can_chain_to": ["heavy"]
	},
	"heavy": {
		"damage": 50,
		"duration": 0.8,
		"combo_window": 0.0,
		"knockback": 400,
		"can_chain_to": []
	}
}

func _ready() -> void:
	debug.visible = false
	if !player:
		player = get_parent().get_parent()
	
	if !attack_hitbox:
		attack_hitbox = player.get_node("DealDamageArea")
	
	if !attack_collision:
		attack_collision = player.get_node("DealDamageArea/CollisionShape2D")

func enter(previous_state_path: String, data := {}) -> void:
	var attack_type = data.get("attack_type", "light")
	start_attack(attack_type)

func start_attack(attack_type: String) -> void:
	debug.visible = true 
	current_attack_type = attack_type
	var attack_info = attack_data[attack_type]
	
	# Set attack properties
	attack_timer = attack_info.duration
	combo_window = attack_info.combo_window
	can_combo = false
	
	# Enable hitbox
	player.is_attacking = true
	player.attack_damage = attack_info.damage
	attack_hitbox.monitoring = true
	attack_collision.disabled = false
	
	# Stop horizontal movement during attack
	player.velocity.x *= 0.3
	
	print("Starting ", attack_type, " attack (combo: ", combo_count, ")")

func handle_input(event: InputEvent) -> void:
	if can_combo and combo_window > 0:
		var next_attack = get_next_attack_from_input(event)
		if next_attack != "" and can_chain_to(current_attack_type, next_attack):
			_increment_combo()
		
			if combo_count >= max_light_combo:
				_reset_combo()
				return

			start_attack(next_attack)
			print("curr: " + current_attack_type + "\ncombo: " + str(combo_count))
			return
	
	# Handle other inputs (like jumping) after attack
	if attack_timer <= 0:
		if event.is_action_pressed("Fire"):
			emit_signal("transition", self, "Jumping_State", {})

func get_next_attack_from_input(event: InputEvent) -> String:
	if event.is_action_pressed("Light_Attack"):
		return "light"
	elif event.is_action_pressed("Medium_Attack"):
		return "medium"
	elif event.is_action_pressed("Heavy_Attack"):
		return "heavy"
	return ""

func can_chain_to(from_attack: String, to_attack: String) -> bool:
	return to_attack in attack_data[from_attack].can_chain_to

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Update timers
	attack_timer -= delta
	combo_window -= delta
	
	# Enable combo window partway through attack
	if attack_timer <= attack_data[current_attack_type].duration * 0.6:
		can_combo = true
	
	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y += player.stats["gravity"] * delta
	
	# End attack when timer expires and no combo
	if attack_timer <= 0 and combo_window <= 0:
		end_attack()



func end_attack() -> void:
	# Disable hitbox
	player.is_attacking = false
	attack_hitbox.monitoring = false
	attack_collision.disabled = true
	debug.visible = false
	
	# Reset combo
	combo_count = 0
	
	# Transition back to appropriate state
	if player.is_on_floor():
		if abs(player.velocity.x) > 10:
			emit_signal("transition", self, "Running_State", {})
		else:
			emit_signal("transition", self, "Idle_State", {})
	else:
		if player.velocity.y > 0:
			emit_signal("transition", self, "Falling_State", {})
		else:
			emit_signal("transition", self, "Jumping_State", {})

func exit() -> void:
	player.is_attacking = false
	attack_hitbox.monitoring = false
	attack_collision.disabled = true

func _increment_combo():
	combo_count += 1 

func _reset_combo():
	combo_count = 0
