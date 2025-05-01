extends Area2D

@export var break_speed_threshold := 500.0  # Adjust to tune sensitivity

signal platform_broken

func _ready():
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
    if body.is_in_group("player"):
        var velocity = body.velocity
        if velocity.y > break_speed_threshold:
            break_platform()

func break_platform():
    $CollisionShape2D.disabled = true
    visible = false
    emit_signal("platform_broken")
    queue_free()  # Remove platform, or replace with animation/effect
