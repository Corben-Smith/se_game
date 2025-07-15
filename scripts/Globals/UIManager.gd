extends Node

var canvas_layer: CanvasLayer

var pause_ui: PackedScene = preload("res://pause_menu.tscn")
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

func setup_level_ui():
	var pause_menu = pause_ui.instantiate()
	var death_menu = death_ui.instantiate()
	canvas_layer.add_child(pause_menu)
	canvas_layer.add_child(death_menu)
	pass
