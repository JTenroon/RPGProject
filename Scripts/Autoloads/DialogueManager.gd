extends Node

var _data: DialogueData = null
var _currentLineIndex: int = 0

signal dialogueStarted(speakerName: String, firstLine: String)
signal lineChanged(line: String)
signal dialogueEnded


func start(data:DialogueData) -> void:
	if data == null or data.lines.is_empty():
		return
	

	_data = data
	_currentLineIndex = 0

	# Tell GameState we're entering dialogue mode.
	# DialogueManager doesn't manage state itself — it asks GameState to do it.
	GameState.enterState(GameState.State.DIALOGUE)
	emit_signal("dialogueStarted", data.speakerName, data.lines[_currentLineIndex])


func advance() -> void:
	# Guard so this can't be called outside of dialogue without consequence.
	if GameState.currentState != GameState.State.DIALOGUE:
		return
		
	_currentLineIndex += 1

	if _currentLineIndex >= _data.lines.size():
		_end()
	else:
		emit_signal("lineChanged", _data.lines[_currentLineIndex])


func _end() -> void:
	_data.clear()
	_currentLineIndex = 0
	GameState.exitCurrentState()
	emit_signal("dialogueEnded")
