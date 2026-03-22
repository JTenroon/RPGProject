# GameState.gd
# Autoload this first in Project Settings > Autoload, before DialogueManager.
# Godot initializes Autoloads in order — GameState must exist before anything tries to read it.
extends Node
enum State { EXPLORE, DIALOGUE, COMBAT}
var currentState: State = State.EXPLORE

# Emitted whenever the state changes, so any node can react —
# e.g. the player disabling movement, UI panels showing or hiding.
signal stateChanged(newState: State)

func enterState(newState: State) -> void:
	if currentState == newState:
		return
	currentState = newState
	emit_signal("stateChanged", newState)

func exitCurrentState() -> void:
	# Convenience method — always returns to EXPLORE.
	# Later you might want a state stack here instead (e.g. pause over inventory).
	enterState(State.EXPLORE)
