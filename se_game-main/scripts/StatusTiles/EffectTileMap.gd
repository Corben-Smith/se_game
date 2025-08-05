# EffectTileMap.gd
extends TileMap
class_name EffectTileMap

@export var effect_tiles: Array[StatusEffectTile] = []
@export var detection_shape: Shape2D = RectangleShape2D.new():
    set(value):
        detection_shape = value
        if is_inside_tree() and $DetectionArea/CollisionShape2D:
            $DetectionArea/CollisionShape2D.shape = value

var _tile_effects := {}  # tile_id: StatusEffectTile
var _active_effects := {}  # player: Array[StatusEffect]

func _ready() -> void:
    # Initialize detection area
    var area := Area2D.new()
    area.name = "DetectionArea"
    var collision := CollisionShape2D.new()
    collision.shape = detection_shape
    collision.shape.extents = cell_quadrant_size * 0.5
    area.add_child(collision)
    add_child(area)
    
    area.body_entered.connect(_on_body_entered)
    area.body_exited.connect(_on_body_exited)
    
    # Build tile effect lookup
    for effect_tile in effect_tiles:
        _tile_effects[effect_tile.tile_id] = effect_tile

func _on_body_entered(body: Node2D) -> void:
    if not body is Player:
        return
        
    var player := body as Player
    var cell := local_to_map(player.global_position)
    var tile_id := get_cell_source_id(0, cell)
    
    if _tile_effects.has(tile_id):
        var effect_tile := _tile_effects[tile_id]
        var effect := effect_tile.status_effect.duplicate_deep()
        
        player.status_manager.apply_status(effect)
        
        if not _active_effects.has(player):
            _active_effects[player] = []
        _active_effects[player].append(effect)

func _on_body_exited(body: Node2D) -> void:
    if not body is Player or not _active_effects.has(body):
        return
        
    var player := body as Player
    for effect in _active_effects[player]:
        var effect_tile := _tile_effects.values().filter(
            func(t): return t.status_effect == effect
        )[0]
        
        if effect_tile.remove_on_exit:
            player.status_manager.remove_status(effect)
    
    _active_effects.erase(player)

func _process(_delta: float) -> void:
    # Continuous effect checking while player is on tile
    for player in _active_effects.keys():
        var cell := local_to_map(player.global_position)
        var tile_id := get_cell_source_id(0, cell)
        
        # If player moved to a non-effect tile, remove effects
        if not _tile_effects.has(tile_id):
            for effect in _active_effects[player]:
                player.status_manager.remove_status(effect)
            _active_effects.erase(player)
