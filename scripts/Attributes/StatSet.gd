extends Resource
class_name StatSet 

var stats: Dictionary = {}

func _init() -> void:
    pass

func _get(property: StringName):
    if stats.has(property):
        return stats[property].get_value()
    return null

# Override _set to enable dictionary-style assignment
# func _set(property, value) -> bool:
#     if stats.has(property):
#         # If the value is a Stat object, replace the existing Stat
#         if value is Stat:
#             stats[property] = value
#         # If the value is a float, update the base value of the Stat
#         elif typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
#             stats[property].base_value = value
#         else:
#             push_error("Invalid value type for property '%s'." % property)
#             return false
#         return true
#     return false

# Get the final value of a stat
func get_stat(stat_name: String) -> Stat:
    if stats.has(stat_name):
        return stats[stat_name]
    else:
        push_error("Stat '%s' does not exist." % stat_name)
        return null

# Add a modifier to a stat
func add_modifier(stat_name: String, modifier: Modifier) -> void:
    if stats.has(stat_name):
        stats[stat_name].add_modifier(modifier)
    else:
        push_error("Stat '%s' does not exist." % stat_name)

# Remove a modifier from a stat
func remove_modifier(stat_name: String, modifier: Modifier) -> void:
    if stats.has(stat_name):
        stats[stat_name].remove_modifier(modifier)
    else:
        push_error("Stat '%s' does not exist." % stat_name)

