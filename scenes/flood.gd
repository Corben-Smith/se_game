extends Node2D

@export var rise_speed: float = 20.0
@export var stop_y: Node2D
@export var delay_before_rising: float = 3.0

var rising := false
var time_passed := 0.0
var start_position: Vector2

func _ready():
	if !stop_y:
		push_error("nostopy")
	start_position = global_position
	connect("body_entered", _on_body_entered)

func _process(delta):
	if !rising:
		time_passed += delta
		if time_passed >= delay_before_rising:
			rising = true
	elif global_position.y > stop_y.global_position.y:
		global_position.y -= rise_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
