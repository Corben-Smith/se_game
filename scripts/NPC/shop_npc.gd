extends InteractableArea2D
class_name ShopNPC

@export var move_cam: bool = true
@export var camera_manager: CameraManager
@export var zoom: Vector2 = Vector2(2.0, 2.0)

@onready var shader_mat = $Sprite2D.material
@export var shop_scene: PackedScene = preload("res://scenes/shop.tscn")

var shop_ui: Node
var interactable: bool = true
var interaction_timeout: bool = false
var interacting: bool = false

func _ready() -> void:
	add_to_group("persistant")
	shader_mat.set_shader_parameter("show_outline", false)

	if not camera_manager:
		camera_manager = get_tree().root.get_node_or_null("CameraManager")
		if not camera_manager:
			push_error("CameraManager not found in scene tree.")

	super()

func _create_shop() -> void:
	shop_ui = shop_scene.instantiate()
	UI_Manager.canvas_layer.add_child(shop_ui)
	get_tree().paused = true
	shop_ui.visible = true
	# Optional: connect close button
	if shop_ui.has_signal("shop_closed"):
		shop_ui.connect("shop_closed", Callable(self, "_handle_shop_closed"))

func _handle_shop_closed() -> void:
	if shop_ui:
		shop_ui.queue_free()
	shop_ui = null
	get_tree().paused = false
	interaction_timeout = true
	if move_cam:
		camera_manager.reset_camera()
	_reset_outline()

func _on_player_entered():
	if interactable:
		_set_outline()

func _on_player_exited():
	interaction_timeout = false 
	interacting = false
	_reset_outline()
	if move_cam:
		camera_manager.reset_camera()
	if shop_ui:
		_handle_shop_closed()

func _interact():
	if interactable and not interaction_timeout and not interacting:
		interacting = true
		if move_cam:
			camera_manager.set_camera(self.position, zoom)
		if not shop_ui:
			_create_shop()

func _reset_outline():
	shader_mat.set_shader_parameter("show_outline", false)

func _set_outline():
	shader_mat.set_shader_parameter("show_outline", true)
