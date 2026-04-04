extends Node2D

@onready var defend: menuButton = $"Defend Button"
@onready var attack: menuButton = $"Attack Button"
@onready var magic: menuButton = $"Magic Button"
@onready var item: menuButton = $"Item Button"

func hideRoot() -> void:
	defend.hide()
	magic.hide()
	item.hide()
	defend.hide()
