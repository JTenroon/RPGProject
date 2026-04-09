extends Node

@onready var aggroed: CharacterBody2D = null
var _party: Array [Combatant]
var _combatants: Array [Combatant]
var _enemies: Array [Combatant]
var queue: Array [combatAction]

var _combatActive: bool
var _partyScore: int
var _enemyScore: int

signal combatStarted(party:Array[Combatant])
signal updateUI(party:Array[Combatant])

func start(starter: CharacterBody2D) -> void:
	#switches game state
	GameState.enterState(GameState.State.COMBAT)
	_combatActive = true
	
	#the player sends the command to the CombatManager to aggro enemies
	#in the CallRadius of the collided enemy  
	aggroed = starter
	_aggroEnemies(aggroed)
	_getParty()
	_concatenate()
	
	#debug printer
	_printCombatants()
	emit_signal("combatStarted", _party)
	hideTargets()

#COMBAT LOGIC EXECUTED HERE
func _physics_process(delta: float) -> void:
	#State safety check
	if _combatActive:
		#tick adds ATB
		_tick()
		#executeQueue completes all moves in Queue via pop_front
		_executeQueue()

#PRIVATE LOGIC HANDLING FUNCTIONS

#all enemies in the call radius are aggroed and added to the enemy list
#NEEDTO: ADD LIMIT ON SIZE OF ARRAY TO THREE
func _aggroEnemies(starter: CharacterBody2D) -> void:
	
	var callRadius := starter.get_node_or_null("CallRadius")
	
	for body in callRadius.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			_enemies.append(body)

#walks scene tree to get array of party members
func _getParty():
	for members in get_tree().get_nodes_in_group("player"):
		_party.append(members)
	for members in get_tree().get_nodes_in_group("party"):
		_party.append(members)

#adds enemies and party together into one array
func _concatenate():
	for members in _party:
		_combatants.append(members)
	for enemy in _enemies:
		_combatants.append(enemy)

#debug fxn
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
		_assignTargets()

func _resolveAction(action : combatAction) -> void:
	
	print(action.user.name, " used ", action.ability.actionName," against ", action.target.name,"!")
	
	if action.ability.multiTarget:
		if action.user is AIControlled:
			for member in getParty():
				action.target = member
				applyDamage(action)
		if action.user is playerControlled:
			for enemy in getEnemies():
				applyDamage(action)
	else:
		applyDamage(action)

func _updateUI() -> void:
	emit_signal("updateUI", _party)

func _assignTargets() -> void:
	var index: int = 0
	var aliveEnemies = _enemies.filter(func(e): return !e.isDead)
	
	if _enemies.size() == 0:
		printerr("ERROR: NO ENEMIES IN ARRAY")
	for i in aliveEnemies.size():
		aliveEnemies[i].assignIcon(i)

#Win/Loss logic
#NEEDTO: ADD GAME OVER AND VICTORY STATES
func _victory() -> void:
	print ("You win!!!!!1")
	get_tree().create_timer(0.0).timeout.connect(_cleanup)

func _gameOver() -> void:
	print("GameOVER!!!!!!11")
	get_tree().create_timer(0.0).timeout.connect(_cleanup)

func _cleanup() -> void:
	print("cleanup running")
	_combatActive = false
	for enemy in _enemies:
		if enemy.isDead:
			enemy.queue_free()
	_combatants.clear()
	_party.clear()
	_enemies.clear()
	queue.clear()
	aggroed = null
	GameState.exitCurrentState()

#PUBLIC
func Select(index: int, LorR: int) -> void:
	var activeMembers: Array [Combatant] = getParty().filter(func(e): return e.isActive)
	activeMembers[index].Deselect()
	index += LorR
	if index > activeMembers.size()-1:
		index = 0
	if index < 0:
		index = activeMembers.size()-1
	activeMembers[index].Select()
	print(activeMembers[index].name)

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

func showTargets() -> void:
	var aliveEnemies = _enemies.filter(func(e): return !e.isDead)
	
	for enemies in aliveEnemies:
		enemies.showIcon()

func hideTargets() -> void:
	var aliveEnemies = _enemies.filter(func(e): return !e.isDead)
	
	for enemy in aliveEnemies:
		enemy.hideIcon()

func addToQueue(action: combatAction) -> void:
	queue.append(action)

func checkScore() -> void:
	print("checking score")
	var aliveEnemies = _enemies.filter(func(e): return !e.isDead)
	var aliveParty = _party.filter(func(p): return !p.isDead)
	
	if aliveEnemies.size() == 0:
		_victory()
	elif aliveParty.size() == 0:
		_gameOver()
#called for multitarget moves and AI logic
func getParty() -> Array[Combatant]:
	return _party.filter(func(e): return !e.isDead)
#called for multitarget moves
func getEnemies() -> Array[Combatant]:
	return _enemies.filter(func(e): return !e.isDead)
