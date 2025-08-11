extends Node

var canvas_layer: CanvasLayer

var pause_ui: PackedScene = preload("res://scenes/pause_menu.tscn")
var death_ui: PackedScene = preload("res://game_over.tscn")

var dim_rect: ColorRect
var tween: Tween

func dim_screen(duration: float = 1.0):
	if dim_rect:
		return # Already dimmed
	dim_rect = ColorRect.new()
	dim_rect.color = Color(0, 0, 0, 0.0) # fully transparent at start
	dim_rect.size = get_viewport().get_visible_rect().size
	dim_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas_layer.add_child(dim_rect)
	dim_rect.move_to_front()

	# Fade in
	tween = create_tween()
	tween.tween_property(dim_rect, "color:a", 1.0, duration) # a = alpha channel
	await tween.finished

func remove_dim(duration: float = 1.0):
	if not dim_rect:
		return
	# Fade out
	tween = create_tween()
	tween.tween_property(dim_rect, "color:a", 0.0, duration)
	await tween.finished

	dim_rect.queue_free()
	dim_rect = null


func _ready():
	# Get the root node of the current scene
	var root_node = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

	# Loop through the children of the root node
	for child in root_node.get_children():
		# Check if the child is a CanvasLayer
		if child is CanvasLayer:
			canvas_layer = child
			# You can now work with the first_canvas_layer node
			break  # Exit the loop once the first CanvasLayer is found

	canvas_layer = CanvasLayer.new()
	root_node.add_child(canvas_layer)

func setup_level_ui():
	var root_node = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	var new_canvas_layer = CanvasLayer.new()
	root_node.add_child(new_canvas_layer)
	canvas_layer = new_canvas_layer
	

	var pause_menu = pause_ui.instantiate()
	var death_menu = death_ui.instantiate()
	canvas_layer.add_child(pause_menu)
	canvas_layer.add_child(death_menu)
	pass

func add_element(control: Control):
	canvas_layer.add_child(control)
