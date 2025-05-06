extends Node2D
class_name CameraManager

@export var follow_speed_y: float = 3.0
@export var follow_speed_x: float = 10.0
@export var player: Player = null

@export var default_bounds: CameraBounds = null

@onready var camera: Camera2D = $Camera2D

var areas: Array[CameraZone] = []
@onready var areas_container: Node2D = $Areas
@onready var bounds_container: Node2D = $Bounds

var following_player: bool = true
var active_bounds: CameraBounds = null

@export var offset: Vector2 = Vector2(0, -50)

@export var zoom: Vector2 = Vector2(1.5, 1.5)
var tween: Tween


func _ready() -> void:
	camera.set_zoom(zoom)
	if !player:
		push_error("PLAYER NOT SET ON CAM MANAGER")

	for child in bounds_container.get_children():
		if child is CameraBounds:
			child.player_entered.connect(_on_player_entered_bounds)
			child.player_exited.connect(_on_player_exited_bounds)

	for child in areas_container.get_children():
		if child is CameraZone:
			child.player_entered.connect(_handle_entry)
			child.player_exited.connect(_handle_exit)
			areas.append(child)
			
	# Set default bounds if provided
	if default_bounds:
		set_camera_bounds(default_bounds)

var refollow: bool = false

func _physics_process(delta: float) -> void:
	if following_player:
		smooth_follow(player.global_position, delta)

func _handle_entry(zone: CameraZone):
	following_player = false

	tween = create_tween()
	# tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_method(camera.set_zoom, camera.zoom, zone.zoom, 0.75)# Smoothly move the camera to the zone's position
	tween.parallel().tween_property(camera, "position", zone.pos.global_position, 0.75)
	

func _handle_exit(zone: CameraZone):
	if tween:
		tween.stop()

	following_player = true 
	tween = self.create_tween()
	# tween.set_trans(Tween.TRANS_SINE)

	tween.tween_method(camera.set_zoom, camera.zoom, zoom, 0.75)
	# tween.parallel().tween_method(smooth_refollow, zone.pos.global_position, player.global_position, 1.0)

	tween.finished.connect(_on_exit_tween_finished)

	# following_player = true

func _on_exit_tween_finished():
	refollow = false
	# Add any logic you want here

# Set camera bounds from a CameraBounds object
func set_camera_bounds(bounds: CameraBounds) -> void:
	if !bounds:
		return
		
	active_bounds = bounds
	var rect = bounds.get_bounds_rect()

	# camera.limit_left = rect.position.x
	# camera.limit_right = rect.position.x + rect.size.x
	# camera.limit_top = rect.position.y
	# camera.limit_bottom = rect.position.y + rect.size.y
	limit_left = rect.position.x
	limit_right = rect.position.x + rect.size.x
	limit_top = rect.position.y
	limit_bottom = rect.position.y + rect.size.y

# Clear camera bounds
func clear_camera_bounds() -> void:
	camera.limit_left = -10000000
	camera.limit_right = 10000000
	camera.limit_top = -10000000
	camera.limit_bottom = 10000000

	limit_left = -10000000
	limit_right = 10000000
	limit_top = -10000000
	limit_bottom = 10000000
	active_bounds = null

# # Function to bound a position within the camera limits
# func bound_position(target_position: Vector2) -> Vector2:
#     var half_width = get_viewport_rect().size.x / (2 * camera.zoom.x)
#     var half_height = get_viewport_rect().size.y / (2 * camera.zoom.y)
#
#     var bounded_x = clamp(target_position.x, camera.limit_left + half_width, camera.limit_right - half_width)
#     var bounded_y = clamp(target_position.y, camera.limit_top + half_height, camera.limit_bottom - half_height)
#
#     return Vector2(bounded_x, bounded_y)

var limit_left = -10000000
var limit_right = 10000000
var limit_top = -10000000
var limit_bottom = 10000000

func bound_position(target_position: Vector2) -> Vector2:
	# Calculate the visible area in world space
	var viewport_size = get_viewport_rect().size
	var half_width = viewport_size.x / (2 * camera.zoom.x)
	var half_height = viewport_size.y / (2 * camera.zoom.y)
	
	# Adjust bounds to account for screen size and zoom
	var min_x = limit_left + half_width
	var max_x = limit_right - half_width
	var min_y = limit_top + half_height
	var max_y = limit_bottom - half_height
	
	# If the area is smaller than the viewable area, center the camera
	if min_x > max_x:
		var center_x = (limit_left + camera.limit_right) / 2
		min_x = center_x
		max_x = center_x
	
	if min_y > max_y:
		var center_y = (limit_top + camera.limit_bottom) / 2
		min_y = center_y
		max_y = center_y
	
	# Bound the position
	var bounded_x = clamp(target_position.x, min_x, max_x)
	var bounded_y = clamp(target_position.y, min_y, max_y)
	return Vector2(bounded_x, bounded_y)

func smooth_follow(target_position: Vector2, delta: float):
	var camera_pos = camera.position

	# Get the bounded target position
	var bounded_target = bound_position(target_position + offset)

	# Snap to X quickly
	var new_x = lerp(camera_pos.x, bounded_target.x, follow_speed_x * delta)

	# Smooth/damped Y
	var new_y = lerp(camera_pos.y, bounded_target.y, follow_speed_y * delta)

	camera.position = Vector2(new_x, new_y)
	
func set_camera(pos: Vector2, set_zoom: Vector2):
	following_player = false

	var tween := create_tween()
	# tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_method(camera.set_zoom, camera.zoom, set_zoom, 0.75) # Smoothly move the camera to the zone's position
	
	# Apply bounds if active
	var bounded_pos = bound_position(pos)
	tween.parallel().tween_property(camera, "position", bounded_pos, 1.0)

func reset_camera():
	following_player = true 
	var tween = self.create_tween()

	tween.tween_method(camera.set_zoom, camera.zoom, zoom, 0.75)
	tween.finished.connect(_on_exit_tween_finished)

# Detect when player enters a bounds area
func _on_player_entered_bounds(bounds: CameraBounds) -> void:
	print("entering bounds")
	set_camera_bounds(bounds)
	
# Detect when player exits a bounds area
func _on_player_exited_bounds(bounds: CameraBounds) -> void:
	if active_bounds == bounds:
		# Optionally revert to default bounds
		if default_bounds:
			set_camera_bounds(default_bounds)
		else:
			clear_camera_bounds()



func adjust_zoom_to_bounds():
	var viewport_size = get_viewport_rect().size
	var bounds_width = limit_right - limit_left
	var bounds_height = limit_bottom - limit_top

	# Calculate minimum zoom so nothing outside bounds is visible
	var zoom_x = viewport_size.x / bounds_width
	var zoom_y = viewport_size.y / bounds_height

	# Use the smaller zoom to ensure both dimensions fit
	var min_zoom = 1.0 / max(zoom_x, zoom_y)
	camera.zoom = Vector2(min_zoom, min_zoom)
