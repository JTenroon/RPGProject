extends Node

@onready var aggroed: CharacterBody2D = null
var _party: Array [Combatant]
var _combatants: Array [Combatant]
var _enemies: Array [Combatant]
var queue: Array [combatAction]

var _partyScore: int
var _enemyScore: int

signal combatStarted(party:Array[Combatant])
signal updateUI(party:Array[Combatant])

func start(starter: CharacterBody2D) -> void:
	
	GameState.enterState(GameState.State.COMBAT)
	
	aggroed = starter
	_aggroEnemies(aggroed)
	_getParty()
	_concatenate()
	_printCombatants()
	emit_signal("combatStarted", _party)
	

func _physics_process(delta: float) -> void:
	if GameState.currentState == GameState.State.COMBAT:
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
	for fighter in _combatants:
		fighter.addATB()

func _executeQueue() -> void:
	while queue.size() > 0:
		var action = queue.pop_front()
		_resolveAction(action)

func _resolveAction(action : combatAction) -> void:
	
	print(action.user.name, " used ", action.ability.actionName," against ", action.target.name,"!")
	
	if action.ability.multiTarget:
		if action.user is AIControlled:
			for member in _party:
				action.target = member
				applyDamage(action)
		if action.user is playerControlled:
			for enemy in _enemies:
				applyDamage(action)
	else:
		applyDamage(action)

func _updateUI() -> void:
	emit_signal("updateUI", _party)

func _victory() -> void:
	print ("You win!!!!!1")
	GameState.exitCurrentState()

func _gameOver() -> void:
	print("GameOVER!!!!!!11")
	GameState.exitCurrentState()

#PUBLIC
func applyDamage(action: combatAction) -> void:
	
	var atk: float
	var def: float
	
	if action.ability.isMagic:
		atk = action.user.stats.MAG
		def = action.target.stats.MDEF
	else:
		atk = action.user.stats.ATK
		def = action.target.stats.DEF 
	
	var rawDamage: float = (atk/pow(2.0,def/atk))*(1.0 * (float(action.ability.power)/100.0)) 
	var damage: int = int(rawDamage)
	
	print("It did ", damage, " damage!")
	action.target.takeDamage(damage)	
	_updateUI()

func addToQueue(action: combatAction) -> void:
	queue.append(action)

func checkScore() -> void:
	var aliveEnemies = _enemies.filter(func(e): return !e.isDead)
	var aliveParty = _party.filter(func(p): return !p.isDead)
	
	if aliveEnemies.size() == 0:
		_victory()
	elif aliveParty.size() == 0:
		_gameOver()

func getParty() -> Array[Combatant]:
	return _party

func getEnemies() -> Array[Combatant]:
	return _enemies
