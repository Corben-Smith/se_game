extends StatusEffect
class_name Levitate_Effect

@export var speed: float = 500
@export var ending_speed: float = 400
@export var duration_value: float = 1.0

func _set_duration_and_time():
    duration = duration_value
    time_remaining = duration


func apply_effect(target, delta: float) -> void:
    if target.is_in_group("player"):
        if time_remaining < (duration/3):
# Calculate how far we are through the final third (0.0 to 1.0)
            var transition_progress = time_remaining / (duration/3)

# Interpolate between speed and ending_speed based on remaining time
# As time_remaining decreases, we get closer to ending_speed
            var current_speed = lerp(ending_speed, speed, transition_progress)

            target.velocity.y = -current_speed
        else:
            target.velocity.y = -speed

    super(target, delta)

func on_apply(target) -> void:
    _set_duration_and_time()
    if target.is_in_group("player"):
        target.velocity.y = -speed
