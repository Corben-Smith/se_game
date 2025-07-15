extends State
class_name Attack_State

@export var player: Player
@export var debug: Sprite2D

var attack_duration := 0.2
var attack_timer := attack_duration

func _ready() -> void:
    if debug:
        debug.visible = false
    if !player:
        player = get_parent().get_parent()

func enter(previous_state_path: String, data := {}) -> void:
    attack_timer = attack_duration
    if debug:
        debug.visible = true
    player.is_attacking = true
    player.deal_damage_area.monitoring = true
    player.get_node("DealDamageArea/CollisionShape2D").disabled = false


func physics_update(delta) -> void:
    player.handle_horizontal_movement()
    player.apply_gravity(delta)

    attack_timer -= delta
    if attack_timer <= 0.0:
        # Clean up after attack
        player.deal_damage_area.monitoring = false
        player.get_node("DealDamageArea/CollisionShape2D").disabled = true
        player.is_attacking = false

        # Return to idle state
        emit_signal("transition", self, "Idle_State", {})

func exit() -> void:
    if debug:
        debug.visible = false

