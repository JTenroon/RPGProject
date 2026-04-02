extends CanvasLayer

const PartyProfile = preload("res://Assets/UI/Combat/party_profile.tscn")

@onready var _partyBox: HBoxContainer = $Control/PartyBox
@onready var _profiles: Array[partyProfile]

func _ready() -> void:
	self.hide()
	CombatManager.combatStarted.connect(_onCombatStarted)
	CombatManager.updateUI.connect(_onUpdateUI)
	GameState.stateChanged.connect(_onStateChange)

func _onCombatStarted(party: Array[Combatant]):

	self.show()

	for member in party:
		var profile = PartyProfile.instantiate() 
		
		_partyBox.add_child(profile)
		profile.init(member)
		
		_profiles.append(profile)

func _onStateChange(newState: GameState.State) -> void:
	
	self.hide()
	for child in _partyBox.get_children():
		child.queue_free()

func _onUpdateUI(party: Array[Combatant]) -> void:
	if GameState.currentState == GameState.State.COMBAT:
		for i in party.size():
			_profiles[i].update(party[i])
