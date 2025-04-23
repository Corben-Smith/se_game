extends Area2D
class_name StatusEffectApplyer

@export var status_effect: StatusEffect = null
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	print("boosting")
	if body.is_in_group("player"):
		if status_effect:
			body.status_manager.apply_effect(status_effect, body)
		else:
			push_error("attemped to add status effect but you didn't provide one")
