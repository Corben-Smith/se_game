extends RefCounted

class_name Inventory

var _last_player_id: int = 100000
var _last_mob_id: int = 200000

var inventory_id: int
var owner: String
var items: Array


func _init(owner: String = "", items: Array = [], is_player: bool = false):
    if is_player:
        inventory_id = _last_player_id
        _last_player_id += 1
    else:
        if _last_mob_id > 299999:
            _last_mob_id = 200000
        inventory_id = _last_mob_id
        _last_mob_id += 1

    self.owner = owner
    self.items = items.duplicate() if items else []

func add_item(item):
    items.append(item)

func remove_item(item):
    if item in items:
        items.erase(item)
    else:
        print("Item '%s' not found in inventory." % item)

func clear_items():
    items.clear()

func _to_string() -> String:
    return "Inventory(owner=%s, items=%s)" % [owner, items]
