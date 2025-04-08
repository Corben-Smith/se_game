extends TileMap
class_name EffectTileMap

# Layer configuration - set these in the Inspector
@export var effect_layers := {
    # layer_index : [effect_resource, sound, particle]
    0 : {"effect": preload("res://effects/slow.tres"), "sfx": "slow_enter"},
    1 : {"effect": preload("res://effects/poison.tres"), "sfx": "poison_enter"},
    2 : {"effect": preload("res://effects/jump_boost.tres"), "sfx": "jump_boost"}
}

@onready var player: Player = $"../Player"  # Adjust path to your player

func _ready():
    # Set collision for all effect layers
    for layer in effect_layers.keys():
        set_layer_enabled(layer, true)
        set_layer_collision_mask(layer, 1)  # Match your player's collision layer

func _physics_process(_delta):
    if !player: return
    
    var tile_pos = local_to_map(player.global_position)
    
    for layer in effect_layers:
        if get_cell_source_id(layer, tile_pos) != -1:  # Tile exists at this layer
            var config = effect_layers[layer]
            
            # Apply effect if not already active
            if !player.status_manager.has_effect(config.effect):
                player.status_manager.apply_effect(config.effect.duplicate())
                
                # Optional sound/visuals
                if config.has("sfx"):
                    $Audio.play(config.sfx)

func _on_player_exited_effect_area():
    # Cleanup when leaving all effect tiles
    for config in effect_layers.values():
        player.status_manager.remove_effect(config.effect)
