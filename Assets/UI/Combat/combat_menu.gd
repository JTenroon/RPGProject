extends CanvasLayer

const PartyProfile = preload("res://Assets/UI/Combat/party_profile.tscn")

@onready var _partyBox: HBoxContainer = $Control/PartyBox
func _ready() -> void:
	self.hide()
	CombatManager.combatStarted.connect(_onCombatStarted)
	GameState.stateChanged.connect(_onStateChange)

func _onCombatStarted(party: Array[CharacterBody2D]):

	self.show()
	for member in party:
		var profile = PartyProfile.instantiate() 
		
		_partyBox.add_child(profile)
		profile.init(member)

func _onStateChange(newState: GameState.State) -> void:
	for child in _partyBox.get_children():
		child.queue_free()
