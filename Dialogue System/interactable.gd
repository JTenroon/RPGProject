extends Node

@export var dialogueData: DialogueData

func interact() -> void:
	
	if GameState.currentState != GameState.State.EXPLORE:
		return
	DialogueManager.start(dialogueData)
	print("Nice interaction buddy")
