extends Resource
class_name ModifierEntry

@export var stat_name: String = ""
@export var modifier_type: Modifier.Type = Modifier.Type.ADDITIVE
@export var modifier_value: float = 0.0

var modifier: Modifier = null

func get_modifier() -> Modifier:
    if modifier == null:
        modifier = Modifier.new(modifier_type, modifier_value)
    return modifier
