extends Node2D
class_name CameraManager

@export var follow_speed: float = 50.0
@export var player: Player = null

@onready var camera: Camera2D = $Camera2D

var areas: Array[CameraZone] = []
@onready var areas_container: Node2D = $Areas

var following_player: bool = true

@export var zoom: Vector2 = Vector2(1.5, 1.5)

func _ready() -> void:
	camera.set_zoom(zoom)
	if !player:
		push_error("PLAYER NOT SET ON CAM MANAGER")

	for child in areas_container.get_children():
		if child is CameraZone:
			child.player_entered.connect(_handle_entry)
			child.player_exited.connect(_handle_exit)
			areas.append(child)

var refollow: bool = false

func _physics_process(delta: float) -> void:
	if following_player:
		smooth_follow(player.global_position, delta)

func _handle_entry(zone: CameraZone):
	following_player = false

	var tween := create_tween()
	# tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_method(camera.set_zoom, camera.zoom, zone.zoom, 0.75)# Smoothly move the camera to the zone's position
	tween.parallel().tween_property(camera, "position", zone.pos.global_position, 1.0)
	

func _handle_exit(zone: CameraZone):
	following_player = true 
	var tween = self.create_tween()
	# tween.set_trans(Tween.TRANS_SINE)

	tween.tween_method(camera.set_zoom, camera.zoom, zoom, 0.75)
	# tween.parallel().tween_method(smooth_refollow, zone.pos.global_position, player.global_position, 1.0)

	tween.finished.connect(_on_exit_tween_finished)

	# following_player = true

func _on_exit_tween_finished():
	refollow = false
	# Add any logic you want here

func smooth_follow(target_position: Vector2, delta: float):
	var camera_pos = camera.position

	# Snap to X quickly
	var new_x = lerp(camera_pos.x, target_position.x, 10 * delta)

	# Smooth/damped Y
	var new_y = lerp(camera_pos.y, target_position.y, 3 * delta)

	camera.position = Vector2(new_x, new_y)
# func smooth_follow(target_position: Vector2, delta: float):
#     var target_x = target_position.x
#     var target_y = lerp(camera.position.y, target_position.y, 5 * delta)  # dampened vertical
#
#     camera.position = Vector2(target_x, target_y)
	
func smooth_refollow(target_position: Vector2, delta):
	camera.position = camera.position.lerp(target_position, follow_speed * delta)
