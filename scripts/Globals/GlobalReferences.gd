extends Node

@export var camera_manager: CameraManager
var player: Player

func _ready() -> void:
	find_player_alternative()

func find_player_alternative():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
