extends Node

var gold = 1000
var exp = 100

@export var item_list: Array[Item] = [
	preload("res://scripts/Items/HealingPotion.tres"),
	preload("res://scripts/Items/LevelUpElixir.tres")
]

# Player Items Inventory
var inventory: Array[InventoryItem] = []
# Player Key Inventory
var key_inventory: Array[String] = []

# Default Items when the player comes to life
func _ready():
	var healing_potion = InventoryItem.new()
	healing_potion.item = item_list[0]  # HealingPotion.tres
	healing_potion.count = 1
	inventory.append(healing_potion)

# Key logic
func add_key(key_id: String):
	if key_id not in key_inventory:
		key_inventory.append(key_id)
		print("Key added to inventory:", key_id)

func has_key(key_id: String) -> bool:
	return key_id in key_inventory

# Items for sale in the shop
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
