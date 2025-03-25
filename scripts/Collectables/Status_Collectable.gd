extends Collectable
class_name Status_Collectable

@export var statuses: Array[StatusEffect] = [] 

func _ready():
    if !statuses or len(statuses):
        push_error("provide a status effect resource")

    connect("body_entered", _on_body_entered)
    connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node2D):
    if body is Player:
        _collect(body)
        queue_free()

func _collect(player: Player):
    if player.status_manager:
        for status in statuses:
            var new_status = status.duplicate_deep()
            player.status_manager.apply_effect(new_status, player)
