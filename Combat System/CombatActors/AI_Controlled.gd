class_name AIControlled

extends Combatant

@export var abilities: AIMoveset

func _chooseAction() -> void:
	
	var action: combatAction = combatAction.new()
	
	action.user = self
	action.ability = _chooseAbility()
	action.target = _chooseTarget()
	
	CombatManager.addToQueue(action)
	
func _chooseAbility() -> Ability:
	return self.abilities.list[randi_range(0,(abilities.list.size()-1))]
	
func _chooseTarget() -> Combatant:
	var aliveParty: Array[Combatant] = CombatManager.getParty().filter(func(e): return !e.isDead)
	return aliveParty[randi_range(0,aliveParty.size()-1)]
