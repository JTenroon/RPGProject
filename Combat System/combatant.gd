class_name Combatant

extends CharacterBody2D

@export var stats: characterStats
var currentHP: int
var currentMP: int
var ATB: int
var ATBMax: int = 500

func _ready() -> void:
	stats.calculate()
	currentHP = stats.currentMaxHP
	currentMP = stats.currentMaxMP

func addATB() -> void:
	
	if ATB >= ATBMax:
		_chooseAction()
		ATB = 0

	elif ATB < ATBMax:
		ATB += stats.SPD
		

func _chooseAction() -> void:
	var action: int = 2
	CombatManager.addToQueue(action)
	pass
