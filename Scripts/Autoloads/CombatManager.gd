extends Node

@onready var aggroed: CharacterBody2D = null
var _party: Array [Combatant]
var _combatants: Array [Combatant]
var _enemies: Array [Combatant]
var queue: Array [combatAction]


signal combatStarted(party:Array[CharacterBody2D])

func start(starter: CharacterBody2D) -> void:
	
	GameState.enterState(GameState.State.COMBAT)
	
	aggroed = starter
	_aggroEnemies(aggroed)
	_getParty()
	_concatenate()
	_printCombatants()
	emit_signal("combatStarted", _party)

func _physics_process(delta: float) -> void:
	_tick()
	_executeQueue()

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

func _tick() -> void:
	for entity in _combatants:
		entity.addATB()

func _executeQueue() -> void:
	if queue:
		for action in queue:
			_resolveAction(action)

func _resolveAction(action : combatAction) -> void:
	if action.ability.multiTarget:
		if action.user is AIControlled:
			for member in _party:
				action.applyDamage(action.user, member,action.ability.power)
		if action.user is playerControlled:
			for enemy in _enemies:
				action.applyDamage(action.user,enemy,action.ability.power)
	else:
		applyDamage(action)
		
func applyDamage(action: combatAction) -> void:
	
	var atk: float
	var def: float
	
	if action.ability.isMagic:
		atk = action.user.stats.MAG
		def = action.target.stats.MDEF
	else:
		atk = action.user.stats.ATK
		def = action.target.stats.DEF 
	
	var rawDamage: float = (atk/pow(2.0,def/atk))*(1.0 + (float(action.ability.power)/100.0)) 
	var damage: int = int(rawDamage)
	
	action.target.takeDamage(damage)	
	
func addToQueue(action: int) -> void:
	queue.append(action)
