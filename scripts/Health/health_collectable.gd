extends Collectable
class_name HealthCollectable

@export var heal_amount: int = 1

func _on_body_entered(body: Node2D):
	if body is Player:
		var health_comp = body.health_component
		if health_comp and health_comp.current_health < health_comp.max_health:
			_collect(body)
			queue_free()

func _collect(player: Player):
	player.health_component.add_health(heal_amount)
