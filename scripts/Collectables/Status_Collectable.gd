# extends Collectable
# class_name Status_Collectable
#
# @export var statuses: Array[StatusEffect] = []
#
# func _ready():
#     if !statuses:
#         push_error("provide a status effect resource")
#
#     connect("body_entered", _on_body_entered)
#     connect("body_exited", _on_body_exited)
#
# func _on_body_entered(body: Node2D):
#     if body is Player:
#         _collect(body)
#         queue_free()
#
# func _collect(player: Player):
#     if player.status_manager:
#         for status in statuses:
#             var new_status = status.duplicate_deep()
#             player.status_manager.apply_effect(new_status, player)
extends Collectable
class_name Status_Collectable

@export var statuses: Array[StatusEffect] = []

func _ready():
    if statuses.is_empty():
        push_error("Provide at least one status effect resource")
        return

    connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D):
    if body is Player:
        _collect(body)
        # Delay freeing to ensure effects are applied
        await get_tree().process_frame
        queue_free()

func _collect(player: Player):
    if !player.status_manager:
        push_error("Player has no status manager!")
        return
        
    for status in statuses:
        if !status:
            push_error("Null status effect in array")
            continue
            
        var new_status = status.duplicate_deep()
        print("Applying status effect: ", new_status.resource_name)
        player.status_manager.apply_effect(new_status, player)
