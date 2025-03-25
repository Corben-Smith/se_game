extends Resource
class_name Modifier

enum Type {
    ADDITIVE,       # Adds to the base value
    MULTIPLICATIVE, # Multiplies the base value
    OVERRIDE        # Overrides the base value
}

@export var type: Type
@export var value: float

# Constructor
func _init(modifier_type: Type, modifier_value: float) -> void:
    type = modifier_type
    value = modifier_value
