extends CharacterBody2D

@export var charName: String = "Ken"
@export var stats: characterStats


var ATB: int

func _ready() -> void:
	stats.calculate()
	stats.printAllStats()
	
