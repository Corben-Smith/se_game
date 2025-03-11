extends StatusEffect
class_name Jump_Boost_Status_Effect

# How much to multiply the player's jump height
@export var jump_multiplier: float = 1.5
# Original jump height (stored to restore it later)
var original_jump_height: float

# Called when the effect is applied
func on_apply(target: Node) -> void:
    original_jump_height = target.jump_force
    target.jump_force = original_jump_height * jump_multiplier
    super(target)

# Called when the effect is removed
func remove_effect(target: Node) -> void:
    target.jump_force = original_jump_height
    super(target)  # Call parent method to clean up
