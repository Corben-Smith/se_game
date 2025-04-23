extends StatusEffect
class_name Levitate_Effect

@export var speed: float = 500

func apply_effect(target, delta: float) -> void:
    if target.is_in_group("player"):
        target.velocity.y = -speed

    super(target, delta)

func on_apply(target) -> void:
    if target.is_in_group("player"):
        target.velocity.y = -speed
