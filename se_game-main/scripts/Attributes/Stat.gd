extends Resource
class_name Stat

@export var base_value: float = 0.0
@export var modifiers: Array = []

# Constructor
func _init(base: float) -> void:
    base_value = base

# Add a modifier
func add_modifier(modifier: Modifier) -> void:
    modifiers.append(modifier)

# Remove a modifier
func remove_modifier(modifier: Modifier) -> void:
    modifiers.erase(modifier)

# Calculate the final value
func get_value() -> float:
    var final_value = base_value
    var additive = 0.0
    var multiplicative = 1.0

    for modifier in modifiers:
        match modifier.type:
            Modifier.Type.ADDITIVE:
                additive += modifier.value
            Modifier.Type.MULTIPLICATIVE:
                multiplicative *= modifier.value
            Modifier.Type.OVERRIDE:
                final_value = modifier.value
                break  # Override ignores all other modifiers

    return (final_value + additive) * multiplicative
