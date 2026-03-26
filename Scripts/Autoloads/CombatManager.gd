extends Node

@onready var aggroed: CharacterBody2D = null
var party: Array [CharacterBody2D]
var combatants: Array [CharacterBody2D]
var enemies: Array [CharacterBody2D]

signal combatStarted(party:Array[CharacterBody2D])

func start(starter: CharacterBody2D) -> void:
	
	GameState.enterState(GameState.State.COMBAT)
	
	aggroed = starter
	_aggroEnemies(aggroed)
	_getParty()
	_concatenate()
	_printCombatants()
	emit_signal("combatStarted", party)


func _aggroEnemies(starter: CharacterBody2D) -> void:
	
	var callRadius := starter.get_node_or_null("CallRadius")
	
	for body in callRadius.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			enemies.append(body)

func _getParty():
	for members in get_tree().get_nodes_in_group("player"):
		party.append(members)
	for members in get_tree().get_nodes_in_group("party"):
		party.append(members)

func _concatenate():
	for members in party:
		combatants.append(members)
	for enemy in enemies:
		combatants.append(enemy)

func _printCombatants():
	for fighter in combatants:
		print(fighter.name)
