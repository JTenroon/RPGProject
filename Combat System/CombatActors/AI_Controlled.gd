class_name AIControlled
extends Combatant

const BOTTOM_ICON: Texture2D = preload("res://Assets/UI/Combat/Combat Menu/BottomFace.png")
const LEFT_ICON: Texture2D = preload("res://Assets/UI/Combat/Combat Menu/LeftFace.png")
const TOP_ICON: Texture2D = preload("res://Assets/UI/Combat/Combat Menu/TopFace.png")

@onready var targetIndicator: TextureRect = $TargetIndicator
@export var abilities: AIMoveset

var indicatorIcons: Array [Texture2D] = [BOTTOM_ICON, LEFT_ICON, TOP_ICON]

func _chooseAction() -> void:
	
	var action: combatAction = combatAction.new()
	
	action.user = self
	action.ability = _chooseAbility()
	action.target = _chooseTarget()
	
	CombatManager.addToQueue(action)
	ATB = 0

func _chooseAbility() -> Ability:
	return self.abilities.list[randi_range(0,(abilities.list.size()-1))]
	
func _chooseTarget() -> Combatant:
	var aliveParty: Array[Combatant] = CombatManager.getParty().filter(func(e): return !e.isDead)
	return aliveParty[randi_range(0,aliveParty.size()-1)]

func assignIcon(index: int) -> void:
	targetIndicator.texture = indicatorIcons[index]

func showIcon() -> void:
	targetIndicator.show()

func hideIcon()-> void:
	targetIndicator.hide()
