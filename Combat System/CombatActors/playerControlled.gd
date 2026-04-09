class_name playerControlled

extends Combatant

@export var attacks: attackSet
@export var spells: spellSet


@onready var combatUI: partyUI = $partyCombatUI


enum combatState{INACTIVE, ROOT, ATTACK, MAGIC, ITEM, TARGET}
enum LeftOrRight{LEFT,RIGHT}
var _currentCombatState: combatState = combatState.INACTIVE

var commandList: Array[Ability]
var blocking: bool
var isSelected: bool = false
var action: combatAction = null
var partyIndex: int

func _ready() -> void:
	
	super()
	print("hidingUI")
	combatUI.hide()
	CombatManager.combatStarted.connect(_onCombatStarted)
	GameState.stateChanged.connect(_onStateChanged)
	print("stateChanged connected: ", GameState.stateChanged.is_connected(_onStateChanged))

func _chooseAction() -> void:
	
	isActive = true
	_currentCombatState = combatState.ROOT
	if CombatManager.getParty().filter(func(e): return e.isSelected).size() <= 0:
		Select()
	elif CombatManager.getParty().filter(func(e): return e.isSelected).size() > 0:
		Deselect()

func _input(event: InputEvent) -> void:

#isActive checks for full ATBall
#isSelected checks for if the player is the selected player
	if isActive && isSelected && !isDead:
		#cycle buttons. Chooses next playerC in the party array.
		if event.is_action_pressed("shoulder_L"):
			_cycle(LeftOrRight.LEFT)
		if event.is_action_pressed("shoulder_R"):
			_cycle(LeftOrRight.RIGHT)

		#actual combat functionality. 
		if event.is_action_pressed("face_right"):
			match _currentCombatState:
				combatState.ROOT:
					_block()
				combatState.ATTACK, combatState.MAGIC, combatState.ITEM, combatState.TARGET:
					_menuBack()

		if event.is_action_pressed("face_down"):
			match _currentCombatState:
				combatState.ROOT:
					_openMagic()
				combatState.ATTACK:
					_chooseAttack(0)
				combatState.MAGIC:
					_chooseMagic(0)
				combatState.ITEM:
					_chooseItem(0)
				combatState.TARGET:
					_chooseTarget(0)

		if event.is_action_pressed("face_left"):
			match _currentCombatState:
				combatState.ROOT:
					_openAttack()
					pass
				combatState.ATTACK:
					_chooseAttack(1)
				combatState.MAGIC:
					_chooseMagic(1)
				combatState.ITEM:
					_chooseItem(1)
				combatState.TARGET:
					_chooseTarget(1)

		if event.is_action_pressed("face_up"):
			match _currentCombatState:
				combatState.ROOT:
					_openItem()
				combatState.ATTACK:
					_chooseAttack(2)
				combatState.MAGIC:
					_chooseMagic(2)
				combatState.ITEM:
					_chooseItem(2)
				combatState.TARGET:
					_chooseTarget(2)

func Select() -> void:
	isSelected = true
	combatUI.clearButtons()
	combatUI.buildRoot()

func Deselect() -> void:
	isSelected = false
	combatUI.clearButtons()
	combatUI.openCursor()

func addATB() -> void:
	super()
	_updateATBall()

func _cycle(LorR: LeftOrRight):
	
	print("cycling")
	if LeftOrRight.LEFT && CombatManager.getParty().size() > 1:
		CombatManager.Select(partyIndex, -1)
	if LeftOrRight.RIGHT && CombatManager.getParty().size() > 1:
		CombatManager.Select(partyIndex, 1)

func _block() -> void:

	#flip a bool that halves damage and then 
	#start a timer or something and when the timer runs out send out a signal
	#to flip bool back and start ticking up ATB again?

	print("blocking")

func _openAttack() -> void:

	#update and populate menu with attack icons
	#debug attack list is populated 
	#print(attacks.list[0].actionName," ", attacks.list[1].actionName," ", attacks.list[2].actionName)
	
	combatUI.openAbilities(attacks.list)
	_currentCombatState = combatState.ATTACK

func _openMagic() -> void:
	#update and populate menu with Magic Icons (same method, pass different resource?)
	combatUI.openAbilities(spells.list)
	_currentCombatState = combatState.MAGIC

func _openItem() -> void:
	#update and populate menu with Items (also same? perhaps?)
	#open da items
	_currentCombatState = combatState.ITEM

func _menuBack() -> void:
	#partial stub
	combatUI.menuBack()
	_currentCombatState = combatState.ROOT

func _cancelTarget() -> void:
	action = null

func _chooseAttack(index: int) -> void:
	action = combatAction.new()
	action.user = self
	action.ability = attacks.list[index]
	_currentCombatState = combatState.TARGET
	combatUI._clearButtons()
	CombatManager.showTargets()

func _chooseMagic(index: int) -> void:
	action = combatAction.new()
	action.user = self
	action.ability = spells.list[index]
	_currentCombatState = combatState.TARGET
	combatUI.clearButtons()
	CombatManager.showTargets()

func _chooseItem(index: int )-> void:
	#stub
	print ("Using item ", index)

func _chooseTarget(index: int) -> void:
	if CombatManager.getEnemies()[index] == null:
		return
	action.target = CombatManager.getEnemies()[index]
	_executeAction()

func _onCombatStarted(party:Array[Combatant]) -> void:
	combatUI.show()

func _executeAction() -> void:
	CombatManager.addToQueue(action)
	Deselect()
	action = null
	combatUI.cycleRestart()
	CombatManager.hideTargets()
	ATB = 0
	isActive = false
	
func _die() -> void:
	super()
	

func _onStateChanged(state: GameState.State) -> void:
	print("state changed")
	if state != GameState.State.COMBAT:
		combatUI.hide()
		_currentCombatState = combatState.INACTIVE
		isActive = false
		action = null
		ATB = 0

func _updateATBall():
	combatUI.updateATB(ATB)
