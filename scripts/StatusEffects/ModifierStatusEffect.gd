extends StatusEffect
class_name ModifierStatusEffect

@export var modifier_entries: Array[ModifierEntry] = []

@export var modifier_type: Modifier.Type
@export var modifer_value: float
@export var stat_name: String

# Add a modifier for a specific stat
func add_modifier(stat_name: String, modifier: Modifier) -> void:
	var entry = ModifierEntry.new()
	entry.stat_name = stat_name
	entry.modifier = modifier
	modifier_entries.append(entry)

# Remove a modifier for a specific stat
func remove_modifier(stat_name: String) -> void:
	modifier_entries = modifier_entries.filter(func(entry): return entry.stat_name != stat_name)

# Override on_apply to add modifiers to the target
func on_apply(target) -> void:
	if target.has_method("add_modifier"):
		target.add_modifier(stat_name, Modifier.new(modifier_type, modifer_value))
		
	# print("on_apply")
	# if target.has_method("add_modifier"):
	#     print("has method on_apply")
	#     for entry in modifier_entries:
	#         print("attempting to apply %s", entry.stat_name)
	#         print("attempting to apply %s", entry.modifier)
	#         target.add_modifier(entry.modifier.duplicate(), entry.stat_name)

# Override remove_effect to remove modifiers from the target
func remove_effect(target) -> void:
	if target.has_method("remove_modifier"):
		target.remove_modifier(stat_name)
		# for entry in modifier_entries:
		#     print("attempting to remove %s", entry.stat_name)
		#     target.remove_modifier(entry.stat_name)
