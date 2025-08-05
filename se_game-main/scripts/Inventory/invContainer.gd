extends GridContainer

@onready var item = preload("res://scenes/Slot.tscn")
var invSize = 10

func _ready():
	# Load slots in
	for i in invSize:
		var itemTemp = item.instantiate()
		add_child(itemTemp)
		
	# Fill in items into slots
	fillInventorySlots()

func fillInventorySlots():
	# Quick reset of slots
	for i in invSize:
		get_child(i).itemName = ""
		get_child(i).itemDes = ""
		get_child(i).itemCost = 0
		get_child(i).itemCount = 0
		get_child(i).hasItem = false
	
	# Fills in inventory into slots
	for i in range(ShopManager.inventory.size()):
		get_child(i).itemName = ShopManager.inventory[i].item.item_name
		get_child(i).itemDes = ShopManager.inventory[i].item.description
		get_child(i).itemCost = ShopManager.inventory[i].item.cost
		get_child(i).itemCount = ShopManager.inventory[i].count
		get_child(i).get_node("Count").text = str(ShopManager.inventory[i].count)
		get_child(i).get_node("Icon").texture = ShopManager.inventory[i].item.icon
		get_child(i).hasItem = true
