# StatusEffectTile.gd
extends Resource
class_name StatusEffectTile

@export var tile_id: int = -1
@export var status_effect: StatusEffect
@export var remove_on_exit: bool = true
