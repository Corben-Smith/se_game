extends Area2D
class_name InteractableArea2D

var player_in_range := false

func _ready():
	print("body_entered")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		_interact()

func _on_body_entered(body):
	print("body_entered")
	if body.is_in_group("player"):
		player_in_range = true
		_on_player_entered()

func _on_body_exited(body):
	print("body_exited")
	if body.is_in_group("player"):
		player_in_range = false
		_on_player_exited()

# "Abstract" methods
func _on_player_entered():
	pass

func _on_player_exited():
	pass

func _interact():
	push_error("You must override _interact() in a subclass.")
