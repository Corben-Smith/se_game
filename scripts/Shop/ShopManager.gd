extends Node

var gold = 1000
var exp = 100

@export var item_list: Array[Item] = [
	preload("res://Scripts/Items/HealingPotion.tres"),
	preload("res://Scripts/Items/LevelUpElixir.tres")
]


var inventory: Array[InventoryItem] = []

func _ready():
	var healing_potion = InventoryItem.new()
	healing_potion.item = item_list[0]  # HealingPotion.tres
	healing_potion.count = 1
	inventory.append(healing_potion)
