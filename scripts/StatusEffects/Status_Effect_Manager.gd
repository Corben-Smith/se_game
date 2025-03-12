extends Node
class_name StatusEffectManager

var active_effects: Dictionary = {}

func apply_effect(effect: StatusEffect, target: Node) -> void:
	if not active_effects.has(effect):
		active_effects[effect] = target
		effect.on_apply(target)
		effect.timeout.connect(_on_remove_effect)
		add_child(effect)

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
