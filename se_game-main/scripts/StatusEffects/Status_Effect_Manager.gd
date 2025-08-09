extends Node
class_name StatusEffectManager

var active_effects: Dictionary = {}

func apply_effect(effect: StatusEffect, target) -> void:
    if not active_effects.has(effect) && effect is ModifierStatusEffect:
        var new_target

        if !target.stats:
            push_error("There was no attribute called stats for the effect to apply to, will try to find anyway")
            new_target = target[find_first_statset(target)]
        else:
            new_target = target.stats

        effect.duplicate_deep()
        active_effects[effect] = new_target 
        effect.on_apply(new_target)
        effect.timeout.connect(_on_remove_effect)
        return 

    if not active_effects.has(effect):
        effect.duplicate_deep()
        active_effects[effect] = target
        effect.on_apply(target)
        effect.timeout.connect(_on_remove_effect)

func remove_effect(effect: StatusEffect) -> void:
    if active_effects.has(effect):
        var target = active_effects[effect]
        effect.remove_effect(target)
        active_effects.erase(effect)

func _process(delta: float) -> void:
    for effect in active_effects.keys():
        effect.apply_effect(active_effects[effect], delta)

func _on_remove_effect(status: StatusEffect):
    remove_effect(status)

func find_first_statset(obj: Object) -> String:
    for property in obj.get_property_list():
        if "type" in property and property.type == TYPE_OBJECT:
            var prop_name = property.name
            var value = obj.get(prop_name)
            if value is StatSet:
                return prop_name
    return ""
