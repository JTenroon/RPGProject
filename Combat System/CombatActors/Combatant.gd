class_name Combatant

extends CharacterBody2D

@export var stats: characterStats

var isDead: bool = false
var currentHP: int
var currentMP: int
var ATB: int
var ATBMax: int = 500
var isActive: bool = false

func _ready() -> void:

	stats.calculate()
	currentHP = stats.currentMaxHP
	currentMP = stats.currentMaxMP

func addATB() -> void:
	
	if isDead:
		return

	if ATB >= ATBMax && !isActive:
		_chooseAction()

	elif ATB < ATBMax:
		ATB += stats.SPD

func _chooseAction() -> void:
	pass

func takeDamage(damage: int) -> void:
	currentHP -= damage
	print(self.name, " has ", currentHP, "HP left!")
	if currentHP <= 0:
		currentHP = 0
		
		isDead = true
		CombatManager.checkScore()
