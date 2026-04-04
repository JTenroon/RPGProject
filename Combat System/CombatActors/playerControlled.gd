class_name playerControlled

extends Combatant

@export var attacks: attackSet
@export var spells: spellSet


@onready var combatUI: partyUI = $partyCombatUI


enum combatState{INACTIVE, ROOT, ATTACK, MAGIC, ITEM, TARGET}
var _currentCombatState: combatState = combatState.INACTIVE

var commandList: Array[Ability]
var blocking: bool
var action: combatAction = null

func _ready() -> void:
	
	super()
	print("hidingUI")
	combatUI.hide()
	CombatManager.combatStarted.connect(_onCombatStarted)
	GameState.stateChanged.connect(_onStateChanged)

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("face_right"):
		match _currentCombatState:
			combatState.ROOT:
				_block()
			combatState.ATTACK or combatState.MAGIC or combatState.ITEM:
				_menuBack()
			combatState.TARGET:
				_cancelTarget()


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
				pass

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
				pass

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
				pass

func addATB() -> void:
	super()
	_updateATBall()

func _block() -> void:

	#flip a bool that halves damage and then 
	#start a timer or something and when the timer runs out send out a signal
	#to flip bool back and start ticking up ATB again?

	print("blocking")

func _openAttack() -> void:
	#update and populate menu with attack icons
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
	_currentCombatState = combatState.ROOT

func _cancelTarget() -> void:
	action = null

func _chooseAttack(index: int) -> void:
	action = combatAction.new()
	action.user = self
	action.ability = attacks.list[index]
	_currentCombatState = combatState.TARGET

func _chooseMagic(index: int) -> void:
	action = combatAction.new()
	action.user = self
	action.ability = spells.list[index]
	_currentCombatState = combatState.TARGET

func _chooseItem(index: int )-> void:
	#stub
	print ("Using item ", index)

func _onCombatStarted(party:Array[Combatant]) -> void:
	combatUI.show()

func _onStateChanged(state: GameState.State) -> void:
	if state != GameState.State.COMBAT:
		combatUI.hide()

func _updateATBall():
	combatUI.updateATB(ATB)

func _chooseAction() -> void:
	
	_currentCombatState = combatState.ROOT
	combatUI.activateMenu()
