extends Area2D

func _on_body_entered(body:Node2D) -> void:
    if body is Player:
        body.global_position = Vector2(0, -500)
    pass

