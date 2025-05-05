extends CanvasLayer

var currentItem = 0
<<<<<<< HEAD

func _ready():
	switchItem(0)
=======
var select = 0

>>>>>>> feature/corben

func _on_close_pressed() -> void:
	$Anim.play("TransOut")


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "TransOut":
		get_tree().paused = false
		self.visible = false

<<<<<<< HEAD
func switchItem(select: int) -> void:
	if select < 0 or select >= ShopManager.item_list.size():
		return
	currentItem = select
	var item = ShopManager.item_list[currentItem]
	$Control/Name.text = item.item_name
	$Control/Des.text = item.description + "\nCost: " + str(item.cost)
	$Control/Sprite2D.texture = item.icon
	print(item)
=======
func switchItem(select):
	for i in range(ShopManager.items.size()):
		if select == i:
			currentItem = select
			get_node("Control/Name").text = ShopManager.items[currentItem]["Name"]
			get_node("Control/Des").text = ShopManager.items[currentItem]["Des"]
			get_node("Control/Des").text += "\nCost: " + str(ShopManager.items[currentItem]["Cost"])
			get_node("Control/Sprite2D").texture = ShopManager.items[currentItem]["Icon"]
			print(ShopManager.items[currentItem])
>>>>>>> feature/corben


func _on_next_pressed() -> void:
	switchItem(currentItem + 1)

func _on_prev_pressed() -> void:
	switchItem(currentItem - 1)


func _on_buy_pressed() -> void:
<<<<<<< HEAD
	var item = ShopManager.item_list[currentItem]

	if ShopManager.gold >= item.cost:
		var has_item = false
		for entry in ShopManager.inventory:
			if entry.item.item_name == item.item_name:
				entry.count += 1
				has_item = true
				break
		if not has_item:
			var new_entry = InventoryItem.new()
			new_entry.item = item
			new_entry.count = 1
			ShopManager.inventory.append(new_entry)
		
		ShopManager.gold -= item.cost
		print("Bought:", item.item_name)
	else:
		print("Not enough gold!")
=======
	var hasItem = false
	if ShopManager.gold > ShopManager.items[currentItem]["Cost"]:
		for i in ShopManager.inventory:
			if ShopManager.inventory[i]["Name"] == ShopManager.items[currentItem]["Name"]:
				ShopManager.inventory[i]["Count"] += 1
				hasItem = true
		if hasItem == false:
			var tempDic = ShopManager.items[currentItem]
			tempDic["Count"] = 1
			ShopManager.inventory[ShopManager.inventory.size()] = tempDic
		ShopManager.gold -= ShopManager.items[currentItem]["Cost"]
	print(ShopManager.inventory)
>>>>>>> feature/corben
	
