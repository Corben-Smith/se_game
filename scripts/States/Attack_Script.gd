extends State
class_name Attack_State

@export var player: CharacterBody2D 

var attack_duration := 0.2

func _ready() -> void:
	if !player:
		player = get_parent().get_parent()

func enter(previous_state_path: String, data := {}) -> void:
	player.is_attacking = true
	player.deal_damage_area.monitoring = true
	player.get_node("DealDamageArea/CollisionShape2D").disabled = false

	await get_tree().create_timer(attack_duration).timeout

	player.deal_damage_area.monitoring = false
	player.get_node("DealDamageArea/CollisionShape2D").disabled = true
	player.is_attacking = false

	# Go back to idle
	emit_signal("transition", self, "Idle_State", {})
