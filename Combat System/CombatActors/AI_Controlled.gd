class_name AIControlled

extends Combatant

@export var abilities: AIMoveset

func _chooseAction() -> void:
	var action: combatAction
	action.user = self
	action.ability = _chooseAbility()

func _chooseAbility() -> Ability:
	return
	
