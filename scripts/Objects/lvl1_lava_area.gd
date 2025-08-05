extends Area2D
@export var respawn_position: Vector2



func _on_body_entered(body):
	if body is CharacterBody2D:
		body.global_position = respawn_position
