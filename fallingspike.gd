extends Node2D
@export var fall_speed: float = 300.0
@export var wait_time: float = 2.0
@export var reset_time: float = 1.5
@export var fall_distance: float = 200.0

var start_position: Vector2
var is_falling := false

func _ready():
	start_position = global_position
	$damage.connect("body_entered", _on_damage_body_entered)
	$detect.connect("body_entered", _on_detect_body_entered)
	set_process(false)

func _process(delta):
	if is_falling:
		global_position.y += fall_speed * delta
		if global_position.y >= start_position.y + fall_distance:
			is_falling = false
			set_process(false)
			await get_tree().create_timer(wait_time).timeout
			hide()
			await get_tree().create_timer(reset_time).timeout
			reset()

func reset():
	global_position = start_position
	show()
	is_falling = false

func _on_detect_body_entered(body):
	if body.is_in_group("player") and !is_falling:
		is_falling = true
		set_process(true)

func _on_damage_body_entered(body):
	if is_falling and body.is_in_group("player"):
		# TEMPORARY logic: attempt to reset to checkpoint
		if body.has_method("reset_to_checkpoint"):
			body.reset_to_checkpoint("Checkpoint")
		else:
			# fallback if checkpoint system not in yet
			get_tree().reload_current_scene()
