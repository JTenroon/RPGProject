extends Node

@export var lines: Array[String] = []

func interact() -> void:
	if GameState.currentState != GameState.State.EXPLORE:
		return
	DialogueManager.start(lines)
