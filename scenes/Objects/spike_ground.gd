extends Area2D
@export var damage_amount := 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
