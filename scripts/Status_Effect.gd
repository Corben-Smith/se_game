extends Node
class_name StatusEffect

var duration: float = 5.0
var time_remaining: float = duration

signal timeout(sender: StatusEffect)

func apply_effect(target: Node, delta: float) -> void:
    time_remaining -= delta
    if time_remaining <= 0:
        emit_signal("timeout", self)
        

func on_apply(target: Node) -> void:
    pass

func remove_effect(target: Node) -> void:
    queue_free()
