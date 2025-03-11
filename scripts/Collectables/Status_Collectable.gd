extends Collectable
class_name Status_Collectable

@export var status: StatusEffect = get_first_status_effect_child(self) 

func _ready():
    connect("body_entered", _on_body_entered)
    connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node2D):
    if body is Player:
        _collect(body)
        queue_free()

func _collect(player: Player):
    if player.status_manager:
        var instance = status.duplicate()
        player.status_manager.apply_effect(instance, player)

func get_first_status_effect_child(parent: Node) -> StatusEffect:
    for child in parent.get_children():
        if child is StatusEffect:
            return child
    return null 
