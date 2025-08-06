extends Sprite2D

@export var warning_color: Color = Color.RED
@export var pulse_speed: float = 3.0
@export var max_scale: float = 1.2
@export var min_scale: float = 0.8

var original_scale: Vector2
var sprite: Sprite2D
var collision_shape: CollisionShape2D

func _ready():
	# Get references to child nodes
	sprite = self
	collision_shape = get_node("CollisionShape2D") if has_node("CollisionShape2D") else null
	
	original_scale = scale
	
	# Set warning appearance
	if sprite:
		sprite.modulate = warning_color
	
	# Start pulsing animation
	_start_pulse_animation()

func _start_pulse_animation():
	var tween = create_tween()
	tween.set_loops()
	
	# Pulse opacity
	var opacity_tween = create_tween()
	opacity_tween.set_loops()
	opacity_tween.tween_property(self, "modulate:a", 0.3, 0.5)
	opacity_tween.tween_property(self, "modulate:a", 1.0, 0.5)

func set_warning_size(size: float):
	scale = original_scale * size
