extends Node

var _lines: Array[String] = []
var _currentLineIndex: int = 0

signal dialogueStarted(firstLine: String)
signal lineChanged(line: String)
signal dialogueEnded


func start(lines: Array[String]) -> void:
	if lines.is_empty():
		return

	_lines = lines
	_currentLineIndex = 0

	# Tell GameState we're entering dialogue mode.
	# DialogueManager doesn't manage state itself — it asks GameState to do it.
	GameState.enterState(GameState.State.DIALOGUE)

	emit_signal("dialogueStarted", _lines[0])


func advance() -> void:
	# Guard so this can't be called outside of dialogue without consequence.
	if GameState.currentState != GameState.State.DIALOGUE:
		return

	_currentLineIndex += 1

	if _currentLineIndex >= _lines.size():
		_end()
	else:
		emit_signal("lineChanged", _lines[_currentLineIndex])


func _end() -> void:
	_lines.clear()
	_currentLineIndex = 0
	GameState.exitCurrentState()
	emit_signal("dialogueEnded")
