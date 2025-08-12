extends State
class_name Attack_State

@export var player: Player
@export var debug: Sprite2D

var attack_duration := 0.2
var attack_timer := attack_duration
var has_dealt_damage = false  # Prevent multiple damage instances per attack

func _ready() -> void:
	if debug:
		debug.visible = false
	if !player:
		player = get_parent().get_parent()

func enter(previous_state_path: String, data := {}) -> void:
	attack_timer = attack_duration
	has_dealt_damage = false
	
	if debug:
		debug.visible = true
	
	player.is_attacking = true
	
	# Enable the damage area
	if player.deal_damage_area:
		player.deal_damage_area.monitoring = true
		# Connect to area_entered if not already connected
		if not player.deal_damage_area.area_entered.is_connected(_on_deal_damage_area_entered):
			player.deal_damage_area.area_entered.connect(_on_deal_damage_area_entered)
	
	# Enable collision shape
	var collision_shape = player.get_node_or_null("DealDamageArea/CollisionShape2D")
	if collision_shape:
		collision_shape.disabled = false
	
	print("Attack started!")

func physics_update(delta) -> void:
	player.handle_horizontal_movement()
	player.apply_gravity(delta)

	attack_timer -= delta
	if attack_timer <= 0.0:
		# Clean up after attack
		cleanup_attack()
		# Return to appropriate state
		if player.velocity.x != 0:
			emit_signal("transition", self, "Running_State", {})
		else:
			emit_signal("transition", self, "Idle_State", {})

func _on_deal_damage_area_entered(area: Area2D) -> void:
	if has_dealt_damage:
		return
	
	# Check if it's an enemy hitbox
	var enemy = area.get_parent()
	if enemy.is_in_group("enemy") and enemy.has_node("HealthComponent"):
		var enemy_health = enemy.get_node("HealthComponent")
		enemy_health.take_damage(player.get_attack_damage())
		has_dealt_damage = true
		print("Player dealt ", player.get_attack_damage(), " damage to enemy!")

func cleanup_attack() -> void:
	player.is_attacking = false
	
	if player.deal_damage_area:
		player.deal_damage_area.monitoring = false
	
	var collision_shape = player.get_node_or_null("DealDamageArea/CollisionShape2D")
	if collision_shape:
		collision_shape.disabled = true

func exit() -> void:
	cleanup_attack()
	if debug:
		debug.visible = false
