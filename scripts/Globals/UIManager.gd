extends Node

var canvas_layer: CanvasLayer

var pause_ui: PackedScene = preload("res://scenes/pause_menu.tscn")
var death_ui: PackedScene = preload("res://game_over.tscn")

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
