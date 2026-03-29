extends Node

@onready var aggroed: CharacterBody2D = null
var _party: Array [CharacterBody2D]
var _combatants: Array [CharacterBody2D]
var _enemies: Array [CharacterBody2D]

signal combatStarted(party:Array[CharacterBody2D])

func start(starter: CharacterBody2D) -> void:
	
	GameState.enterState(GameState.State.COMBAT)
	
	aggroed = starter
	_aggroEnemies(aggroed)
	_getParty()
	_concatenate()
	_printCombatants()
	emit_signal("combatStarted", _party)


func _aggroEnemies(starter: CharacterBody2D) -> void:
	
	var callRadius := starter.get_node_or_null("CallRadius")
	
	for body in callRadius.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			_enemies.append(body)

func _getParty():
	for members in get_tree().get_nodes_in_group("player"):
		_party.append(members)
	for members in get_tree().get_nodes_in_group("party"):
		_party.append(members)

func _concatenate():
	for members in _party:
		_combatants.append(members)
	for enemy in _enemies:
		_combatants.append(enemy)

func _printCombatants():
	for fighter in _combatants:
		print(fighter.name)
