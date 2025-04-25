extends InteractableArea2D
class_name NPC

@onready var box: DialogueBox = $DialogueBox
@onready var shader_mat = $Sprite2D.material
@export var camera_manager: CameraManager

@export var zoom: Vector2 = Vector2(2.0, 2.0)

var interactable: bool = true
var interaction_timeout: bool = false

var current_verse_index: int = 0
@export var lines: Array[LineEntry]

func _ready() -> void:
	shader_mat.set_shader_parameter("show_outline", false)
	box.visible = false
	
	if not camera_manager:
		camera_manager = get_tree().root.get_node_or_null("CameraManager")
		if not camera_manager:
			push_error("CameraManager not found in scene tree.")

	box.finished_dialogue.connect(_handle_dialogue_end)
	super()

func _handle_dialogue_end():
	current_verse_index += 1
	if len(lines) == current_verse_index:
		interactable = false

	interaction_timeout = true
	camera_manager.reset_camera()
	_reset_outline()

func _on_player_entered():
	print("enter")
	if interactable:
		_set_outline()

func _on_player_exited():
	print("exit")
	box.visible = false
	interaction_timeout = false 

	_reset_outline()
	camera_manager.reset_camera()
	box.reset_dialogue()

func _interact():
	print("interact")
	if !box.is_active && interactable && !interaction_timeout:
		box.visible = true

		camera_manager.set_camera(self.position, zoom)

		box.start_dialogue(lines[current_verse_index].lines, "Old Man")

func _reset_outline():
	shader_mat.set_shader_parameter("show_outline", false)

func _set_outline():
	shader_mat.set_shader_parameter("show_outline", true)
