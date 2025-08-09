extends Area2D
class_name CameraBounds

signal player_entered(bounds: CameraBounds)
signal player_exited(bounds: CameraBounds)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Returns the boundary rectangle for this camera bounds area
func get_bounds_rect() -> Rect2:
	var shape = null
	for child in get_children():
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			shape = child
			break
	
	if !shape:
		push_error("CameraBounds must have a CollisionShape2D with a RectangleShape2D")
		return Rect2()
		
	var rect_shape: RectangleShape2D = shape.shape as RectangleShape2D
	var bounds_pos = shape.global_position
	var bounds_extents = rect_shape.size / 2  # RectangleShape2D.size is already the extents (half-size)
	
	return Rect2(
		shape.global_position.x - bounds_extents.x,
		shape.global_position.y - bounds_extents.y,
		bounds_extents.x * 2,
		bounds_extents.y * 2
	)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("player_entered", self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		emit_signal("player_exited", self)
