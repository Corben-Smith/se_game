extends Node2D

@export var move_distance := 200
@export var move_duration := 2.0

var start_position: Vector2
var going_right := true
var tween  # ← no type here

func _ready():
	start_position = $StaticBody2D.global_position
	_start_tween()
	


func _start_tween():
	var target_pos = start_position + Vector2(move_distance if going_right else 0, 0)
	tween = create_tween()
	tween.tween_property($StaticBody2D, "global_position", target_pos, move_duration)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished():
	going_right = !going_right
	_start_tween()
