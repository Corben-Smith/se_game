extends StatusEffect
class_name ModifierStatusEffect

@export var modifier_type: Modifier.Type
@export var modifer_value: float
@export var stat_name: String

var modifier: Modifier = null

func on_apply(target) -> void:
	modifier = Modifier.new(modifier_type, modifer_value)
	if target.has_method("add_modifier"):
		target.add_modifier(stat_name, modifier)
		

# Override remove_effect to remove modifiers from the target
func remove_effect(target) -> void:
	if target.has_method("remove_modifier"):
		target.remove_modifier(stat_name, modifier)
