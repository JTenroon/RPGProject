class_name playerControlled

extends Combatant

@onready var combatUI: partyUI = $partyCombatUI

func _ready() -> void:
	
	super()
	combatUI.hide()
