extends Node

@export var camera_manager: CameraManager
@export var player: Player
var canvas_layer: CanvasLayer

func _ready():
	# Get the root node of the current scene
	var root_node = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

	# Loop through the children of the root node
	for child in root_node.get_children():
		# Check if the child is a CanvasLayer
		if child is CanvasLayer:
			canvas_layer = child
			# You can now work with the first_canvas_layer node
		if child is Player:
			player = child
			# You can now work with the first_canvas_layer node
