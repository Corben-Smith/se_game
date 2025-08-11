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

var checking: bool = false

func _ready() -> void:
	print("=== CAMERA MANAGER DEBUG ===")
	print("Camera zoom set to: ", zoom)
	print("Player assigned: ", player != null)
	print("Camera node found: ", camera != null)
	
	camera.set_zoom(zoom)
	if !player:
		push_error("PLAYER NOT SET ON CAM MANAGER")
		print("ERROR: No player assigned!")
		checking = true
		return 
	else:
		_setup()
	
	

func _setup():
	# Make camera current if it isn't already
	if not camera.is_current():
		camera.make_current()
		print("Made camera current")
	
	for child in bounds_container.get_children():
		if child is CameraBounds:
			child.player_entered.connect(_on_player_entered_bounds)
			child.player_exited.connect(_on_player_exited_bounds)
			print("Connected bounds: ", child.name)

	for child in areas_container.get_children():
		if child is CameraZone:
			child.player_entered.connect(_handle_entry)
			child.player_exited.connect(_handle_exit)
			areas.append(child)
			print("Connected camera zone: ", child.name)
			
	# Set default bounds if provided
	if default_bounds:
		print("Setting default bounds")
		set_camera_bounds(default_bounds)
	else:
		print("No default bounds set")
		# Ensure limits are cleared
		clear_camera_bounds()

var refollow: bool = false

func _physics_process(delta: float) -> void:
	if not player:
		print("trying to find player")
		var players = get_tree().get_nodes_in_group("player")
		if players.size() == 0:
			push_warning("No nodes found in group 'player'")
			return

		var mewo = get_tree().get_nodes_in_group("player")[0]
		if mewo:
			GlobalReferences.player = mewo
			player = GlobalReferences.player
			print("trying to set player")
			_setup()
		return
		
	if refollow && (camera.global_position - player.global_position).abs() < Vector2(50,50):
		smooth_refollow(player.global_position, delta)
	elif following_player:
		refollow = false
		smooth_follow(player.global_position, delta)

func _handle_entry(zone: CameraZone):
	print("Entering camera zone: ", zone.name)
	following_player = false

	tween = create_tween()
	tween.tween_method(camera.set_zoom, camera.zoom, zone.zoom, 0.75)
	tween.parallel().tween_property(camera, "position", zone.pos.global_position, 0.75)


func _handle_exit(zone: CameraZone):
	print("Exiting camera zone: ", zone.name)
	if tween:
		tween.stop()
	following_player = true 
	tween = self.create_tween()

	tween.tween_method(camera.set_zoom, camera.zoom, zoom, 0.75)
	tween.finished.connect(_on_exit_tween_finished)

func _on_exit_tween_finished():
	refollow = false

# Set camera bounds from a CameraBounds object
func set_camera_bounds(bounds: CameraBounds) -> void:
	if !bounds:
		print("ERROR: Trying to set null bounds")
		return
		
	active_bounds = bounds
	var rect = bounds.get_bounds_rect()
	
	print("Setting camera bounds:")
	print("  Rect: ", rect)

	limit_left = rect.position.x
	limit_right = rect.position.x + rect.size.x
	limit_top = rect.position.y
	limit_bottom = rect.position.y + rect.size.y
	
	print("  Limits: L:", limit_left, " R:", limit_right, " T:", limit_top, " B:", limit_bottom)
	
	# Set actual camera limits too
	camera.limit_left = int(limit_left)
	camera.limit_right = int(limit_right)
	camera.limit_top = int(limit_top)
	camera.limit_bottom = int(limit_bottom)
	
	# Check if bounds are too small and adjust zoom if needed
	adjust_zoom_to_bounds()

# Clear camera bounds
func clear_camera_bounds() -> void:
	print("Clearing camera bounds")
	camera.limit_left = -10000000
	camera.limit_right = 10000000
	camera.limit_top = -10000000
	camera.limit_bottom = 10000000

	limit_left = -10000000
	limit_right = 10000000
	limit_top = -10000000
	limit_bottom = 10000000
	active_bounds = null

var limit_left = -10000000
var limit_right = 10000000
var limit_top = -10000000
var limit_bottom = 10000000

func bound_position(target_position: Vector2) -> Vector2:
	var viewport_size = get_viewport_rect().size
	var half_width = viewport_size.x / (2 * camera.zoom.x)
	var half_height = viewport_size.y / (2 * camera.zoom.y)
	
	var min_x = limit_left + half_width
	var max_x = limit_right - half_width
	var min_y = limit_top + half_height
	var max_y = limit_bottom - half_height
	
	if min_x > max_x:
		var center_x = (limit_left + limit_right) / 2
		min_x = center_x
		max_x = center_x
	
	if min_y > max_y:
		var center_y = (limit_top + limit_bottom) / 2
		min_y = center_y
		max_y = center_y
	
	var bounded_x = clamp(target_position.x, min_x, max_x)
	var bounded_y = clamp(target_position.y, min_y, max_y)
	return Vector2(bounded_x, bounded_y)

func smooth_follow(target_position: Vector2, delta: float):
	var camera_pos = camera.position
	var bounded_target = bound_position(target_position + offset)

	var new_x = lerp(camera_pos.x, bounded_target.x, follow_speed_x * delta)
	var new_y = lerp(camera_pos.y, bounded_target.y, follow_speed_y * delta)

	camera.position = Vector2(new_x, new_y)

func smooth_refollow(target_position: Vector2, delta: float):
	var camera_pos = camera.position
	var bounded_target = bound_position(target_position + offset)

	var new_x = lerp(camera_pos.x, bounded_target.x, follow_speed_y * delta)
	var new_y = lerp(camera_pos.y, bounded_target.y, follow_speed_y * delta)

	camera.position = Vector2(new_x, new_y)
	
func set_camera(pos: Vector2, set_zoom: Vector2):
	print("Setting camera to pos: ", pos, " zoom: ", set_zoom)
	following_player = false

	tween = create_tween()
	tween.tween_method(camera.set_zoom, camera.zoom, set_zoom, 0.75)
	
	var bounded_pos = bound_position(pos)
	print("Bounded position: ", bounded_pos)
	tween.parallel().tween_property(camera, "position", bounded_pos, 1.0)

func reset_camera():
	print("Resetting camera")
	following_player = true 
	refollow = true
	tween = self.create_tween()

	tween.tween_method(camera.set_zoom, camera.zoom, zoom, 0.25)
	tween.finished.connect(_on_exit_tween_finished)

func _on_player_entered_bounds(bounds: CameraBounds) -> void:
	print("Player entered bounds: ", bounds.name if bounds else "unnamed")
	set_camera_bounds(bounds)

func _on_player_exited_bounds(bounds: CameraBounds) -> void:
	print("Player exited bounds: ", bounds.name if bounds else "unnamed")
	if active_bounds == bounds:
		if default_bounds:
			set_camera_bounds(default_bounds)
		else:
			clear_camera_bounds()

func adjust_zoom_to_bounds():
	if not active_bounds:
		print("No active bounds for zoom adjustment")
		return
	
	var viewport_size = get_viewport_rect().size
	var bounds_width = limit_right - limit_left
	var bounds_height = limit_bottom - limit_top
	
	print("Viewport size: ", viewport_size)
	print("Bounds size: ", Vector2(bounds_width, bounds_height))
	
	if bounds_width <= 0 or bounds_height <= 0:
		print("Invalid bounds size, skipping zoom adjustment")
		return
	
	# Calculate what zoom level would make bounds fill the viewport
	var zoom_x = viewport_size.x / bounds_width
	var zoom_y = viewport_size.y / bounds_height
	
	# Use the larger zoom to ensure both dimensions fit within bounds
	# (we want to zoom in enough so bounds fill the screen)
	var required_zoom = max(zoom_x, zoom_y)
	
	print("Zoom calculations: zoom_x=", zoom_x, " zoom_y=", zoom_y)
	print("Required zoom: ", required_zoom, " Current zoom: ", camera.zoom.x)
	
	# Only zoom in if bounds are smaller than current view
	if required_zoom > camera.zoom.x:
		var margin_factor = 0.95  # Zoom in slightly less to leave small margin
		var new_zoom_value = required_zoom * margin_factor
		
		print("Adjusting zoom to: ", new_zoom_value)
		
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_method(camera.set_zoom, camera.zoom, Vector2(new_zoom_value, new_zoom_value), 0.5)
	else:
		camera.set_zoom(zoom)
		# tween.tween_method(camera.set_zoom, camera.zoom, zoom, 0.5)
		print("No zoom adjustment needed - bounds are larger than current view")

# Add this function to help debug
func _input(event):
	if event.is_action_pressed("ui_accept"): # Space key
		print("=== CURRENT STATE DEBUG ===")
		print("Camera position: ", camera.global_position)
		print("Camera zoom: ", camera.zoom)
		print("Player position: ", player.global_position if player else "NO PLAYER")
		print("Following player: ", following_player)
		print("Active bounds: ", active_bounds.name if active_bounds else "None")
		print("Camera limits: L:", camera.limit_left, " R:", camera.limit_right, " T:", camera.limit_top, " B:", camera.limit_bottom)
		print("Camera is current: ", camera.is_current())
		print("==========================")
