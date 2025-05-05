extends Area2D 
class_name Collectable

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_exited(body: Node2D):
	pass

func _on_body_entered(body: Node2D):
	if body is Player:
		_collect(body)
		queue_free()

func _collect(player: Player):
	pass
