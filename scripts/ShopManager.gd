extends Node

var gold = 1000
var exp = 100
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
