extends Node

@export var dialogueData: DialogueData

func interact() -> void:
	print("Nice interaction buddy")
	if GameState.currentState != GameState.State.EXPLORE:
		return
	DialogueManager.start(dialogueData)
