extends Resource 
class_name StatusEffect

@export var duration: float = 5.0
var time_remaining: float = duration

signal timeout(sender: StatusEffect)

func apply_effect(target, delta: float) -> void:
	time_remaining -= delta
	if time_remaining <= 0:
		emit_signal("timeout", self)
		

func on_apply(target) -> void:
	push_error("on_apply is not implemented")
	pass

func remove_effect(target) -> void:
	push_error("on_apply is not implemented")

# Generic deep copy method for any StatusEffect
func duplicate_deep() -> StatusEffect:
	var copy = duplicate()  # Create a shallow copy of the resource

	# Iterate over all properties of the resource
	for property in get_property_list():
		var property_name = property["name"]

		# Skip built-in properties and methods
		if property_name in ["script", "resource_path", "resource_name"]:
			continue

		# Get the value of the property
		var value = get(property_name)

		# If the value is a resource, duplicate it recursively
		if value is Resource:
			value = value.duplicate(true)  # Recursively duplicate nested resources
			copy.set(property_name, value)

		# If the value is an array, duplicate its elements recursively
		elif value is Array:
			var new_array = []
			for item in value:
				if item is Resource:
					new_array.append(item.duplicate(true))  # Recursively duplicate nested resources
				else:
					new_array.append(item)  # Copy non-resource items as-is
			copy.set(property_name, new_array)

		# If the value is a dictionary, duplicate its values recursively
		elif value is Dictionary:
			var new_dict = {}
			for key in value:
				if value[key] is Resource:
					new_dict[key] = value[key].duplicate(true)  # Recursively duplicate nested resources
				else:
					new_dict[key] = value[key]  # Copy non-resource values as-is
			copy.set(property_name, new_dict)

	return copy
