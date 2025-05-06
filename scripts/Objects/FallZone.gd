extends Area2D

@export var pos: Node2D
func _on_body_entered(body:Node2D) -> void:
    if body is Player:
        body.global_position = pos.global_position
    pass

