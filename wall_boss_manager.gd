extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.0  # Changed from 100 to something more reasonable
@export var projectile_speed: float = 300.0
@export var spawn_points: Array[Node2D] = []
@export var warning_scene: PackedScene
@export var track_speed: float = 250.0 # Increased for smoother movement
@export var warning_start: Node2D
@export var max_track_time: float = 3.0

var warning: Area2D  # Added type hint
var track_time = 0.0  # Initialize to 0
var player: Node2D
var spawn_timer: Timer
var tracking = false

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(select_enemy_spawn)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
	if spawn_points.is_empty():
		_find_spawn_points()
	
	player = GlobalReferences.player

func _find_spawn_points():
	for child in get_children():
		if child is Node2D and child.name.begins_with("SpawnPoint"):
			spawn_points.append(child)

func _spawn_enemy_random():
	if not player:
		player = GlobalReferences.player
	if spawn_points.is_empty() or not player:
		return
	
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	
	var direction = spawn_point.direction_to_vector(spawn_point.direction)
	
	get_parent().add_child(enemy)
	
	if enemy.has_method("set_velocity"):
		enemy.set_velocity(direction * projectile_speed)
	elif "velocity" in enemy:
		enemy.velocity = direction * projectile_speed

	spawn_point.explode()

func _spawn_enemy_pointed(direction: Vector2, spawn_point):
	if not player:
		player = GlobalReferences.player
	if not player:
		return
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point
	
	get_parent().add_child(enemy)
	
	if enemy.has_method("set_velocity"):
		enemy.set_velocity(direction * projectile_speed)
	elif "velocity" in enemy:
		enemy.velocity = direction * projectile_speed


func get_closest_cardinal_direction_fast(direction: Vector2) -> Vector2:
	var abs_x = abs(direction.x)
	var abs_y = abs(direction.y)
	
	if abs_x > abs_y:
		# Horizontal direction dominates
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		# Vertical direction dominates
		return Vector2.DOWN if direction.y > 0 else Vector2.UP

func _physics_process(delta: float) -> void:
	if tracking and warning and player:
		# Track both X and Y coordinates for full 2D tracking
		warning.global_position.x = move_toward(warning.global_position.x, player.global_position.x, track_speed * delta)
		
		track_time -= delta
		
		# When tracking time expires, spawn enemy and cleanup
		if track_time <= 0:
			var final_position = warning.global_position
			var direction_to_player = (player.global_position - final_position).normalized()
			
			# Spawn enemy at warning position pointing toward player
			_spawn_enemy_pointed(direction_to_player, final_position)
			
			# Clean up warning
			if warning:
				warning.queue_free()
				warning = null
			
			tracking = false
			track_time = 0.0

func _track_player():
	print("track_player")
	
	# Clean up any existing warning
	if warning:
		warning.queue_free()
	
	# Create new warning
	warning = warning_scene.instantiate() as Area2D
	
	# Set starting position
	if warning_start:
		warning.global_position.y = warning_start.global_position.y
		warning.global_position.x = player.global_position.x
	else:
		# Fallback to player position if no start point
		warning.global_position = player.global_position if player else Vector2.ZERO
	
	# Add warning to scene
	get_parent().add_child(warning)
	
	# Reset tracking variables
	track_time = max_track_time
	tracking = true

func spawn_enemy_tracking():
	if player:  # Only track if player exists
		_track_player()

func select_enemy_spawn():
	var v = randf()
	if v < .25 && !tracking:
		spawn_enemy_tracking()
	else:
		spawn_enemy_at_random_point()


func spawn_enemy_at_random_point():
	_spawn_enemy_random()

func add_spawn_point(point: Node2D):
	spawn_points.append(point)

# Helper function to stop current tracking
func stop_tracking():
	if warning:
		warning.queue_free()
		warning = null
	tracking = false
	track_time = 0.0
