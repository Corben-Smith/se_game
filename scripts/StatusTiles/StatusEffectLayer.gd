extends TileMapLayer
class_name ModifierLayer

@export var modifier_entries: Array[ModifierEntry]
@export var collision_margin := 2.0  # Extra margin for collision detection


# Dictionary to track which tiles have active areas
var _tile_areas := {}

func _ready() -> void:
	for m in modifier_entries:
		var mx = m.get_modifier()
		print(m.stat_name)
		print(m.modifier_type)
		print(mx.type)
		print(m.modifier_value)
		print(mx.value)

	_create_collision_areas()



func _create_collision_areas() -> void:
	for cell in get_used_cells():
		var tile_data := get_cell_tile_data(cell)
		if tile_data:
			# Check if tile should have collision (using custom data or always create)
			if true:
				_create_tile_area(cell)

func _create_tile_area(cell_pos: Vector2i) -> void:
	var area := Area2D.new()
	area.name = "EffectArea_%s_%s" % [cell_pos.x, cell_pos.y]
	
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	
	# Get tile size
	var tile_size := _get_tile_size(cell_pos)

	var cell_size := tile_size + Vector2(collision_margin, collision_margin)
	shape.size = cell_size 

	collision.shape = shape
	
	area.add_child(collision)
	add_child(area)
	
	area.position = map_to_local(cell_pos) 
	area.body_entered.connect(_on_body_entered.bind())
	area.body_exited.connect(_on_body_exited.bind())
	
	# Store reference
	_tile_areas[cell_pos] = area

func _get_tile_size(cell_pos: Vector2i) -> Vector2:
	return tile_set.tile_size
		

# Clean up when tiles change
func _on_tilemap_changed() -> void:
	for area in _tile_areas.values():
		area.queue_free()
	_tile_areas.clear()
	_create_collision_areas()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		for entry in modifier_entries:
			body.stats.add_modifier(entry.stat_name, entry.get_modifier())

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		for entry in modifier_entries:
			body.stats.remove_modifier(entry.stat_name, entry.get_modifier())
