extends InteractableArea2D
class_name NPC

var box_scene: PackedScene = preload("res://scenes/NPC/Dialogue.tscn")
var choice_scene

var box: DialogueBox

@onready var shader_mat = $Sprite2D.material

@export var npc_name: String = "Unset"

@export var move_cam: bool = true
@export var camera_manager: CameraManager
@export var zoom: Vector2 = Vector2(2.0, 2.0)

@export var blip: AudioStream = null

var interactable: bool = true
var interaction_timeout: bool = false
var interacting: bool = false

var current_verse_index: int = 0
var current_line_index:int = 0
@export var lines: Array[LineEntry]

func _ready() -> void:
	add_to_group("persistant")
	shader_mat.set_shader_parameter("show_outline", false)

	if not camera_manager:
		camera_manager = get_tree().root.get_node_or_null("CameraManager")
		if not camera_manager:
			push_error("CameraManager not found in scene tree.")

	super()

func _create_box() -> DialogueBox:
	box = box_scene.instantiate()
	box.setup(npc_name, blip)
	UI_Manager.canvas_layer.add_child(box)
	box.finished_dialogue.connect(_handle_dialogue_end)
	return box

func _destroy_box():
	if box:
		box.queue_free()
	box = null

func _handle_dialogue_end():
	_destroy_box()
	current_verse_index += 1
	if len(lines) == current_verse_index:
		interactable = false

	interaction_timeout = true
	if move_cam:
		camera_manager.reset_camera()
	_reset_outline()

func _on_player_entered():
	if interactable:
		_set_outline()

func _on_player_exited():
	interaction_timeout = false 
	current_line_index = 0
	interacting = false

	_reset_outline()
	if move_cam:
		camera_manager.reset_camera()

	if box:
		box.reset_dialogue()
		_destroy_box()

func _interact():
	if interactable && !interaction_timeout && !interacting:
		interacting = true
		if move_cam:
			camera_manager.set_camera(self.position, zoom)

		if !box:
			_create_box()

		box.feed(lines[current_verse_index].lines[current_line_index])
		current_line_index = current_line_index + 1

	elif interacting && box.prepared:
		if current_line_index >= len(lines[current_verse_index].lines):
			current_verse_index += 1
			current_line_index = 0
			if current_verse_index >= len(lines):
				interactable = false

			interaction_timeout = true
			interacting = false
			if move_cam:
				camera_manager.reset_camera()
			_reset_outline()
			_destroy_box()
		else:
			box.feed(lines[current_verse_index].lines[current_line_index])
			current_line_index = current_line_index + 1



func _reset_outline():
	shader_mat.set_shader_parameter("show_outline", false)

func _set_outline():
	shader_mat.set_shader_parameter("show_outline", true)
