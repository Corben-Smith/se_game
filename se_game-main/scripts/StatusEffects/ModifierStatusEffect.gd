extends StatusEffect
class_name ModifierStatusEffect

@export var modifier_entry: ModifierEntry

var modifier: Modifier = null

func on_apply(target) -> void:
	modifier = modifier_entry.get_modifier()
	if target.has_method("add_modifier"):
		target.add_modifier(modifier_entry.stat_name, modifier)
		

# Override remove_effect to remove modifiers from the target
func remove_effect(target) -> void:
	if target.has_method("remove_modifier"):
		target.remove_modifier(modifier_entry.stat_name, modifier)
