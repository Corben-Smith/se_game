extends Collectable
class_name Status_Collectable

@export var status: StatusEffect = null

func _ready():
	if !status:
		push_error("provide a status effect resource")

	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node2D):
	if body is Player:
		_collect(body)
		queue_free()

func _collect(player: Player):
	print("player collected")
	if player.status_manager:
		var new_status = status.duplicate_deep()
		player.status_manager.apply_effect(new_status, player)
