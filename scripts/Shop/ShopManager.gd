extends Node

var gold = 1000
var exp = 100
<<<<<<< HEAD

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
=======
var items = {
	0: {
		"Name": "Healing Potion",
		"Des": "Fully restores HP. Tastes vaguely like strawberries.",
		"Cost": 200,
		"Icon": preload("res://assets/healingItemSprite2d.png")
	},
	1: {
		"Name": "Level-Up Elixir",
		"Des": "A rare elixir infused with ancient knowledge. Grants one level upon use.",
		"Cost": 50,
		"Icon": preload("res://assets/boostItemSprite2d.png")
	}
}

var inventory = {
	0: {
		"Name": "Healing Potion",
		"Des": "Fully restores HP. Tastes vaguely like strawberries.",
		"Cost": 200,
		"Count": 3
	}
}
>>>>>>> feature/corben
