extends CanvasLayer

@export var typewriterSpeed: float = 30.0

@onready var _panel: Panel = $Panel
@onready var _speakerLabel: Label = $Panel/NameLabel
@onready var _dialogueLabel: Label = $Panel/BodyText

var _fullText: String = ""
var _isTyping: bool = false




func _ready() -> void:
	DialogueManager.dialogueStarted.connect(_onDialogueStarted)
	DialogueManager.lineChanged.connect(_onLineChanged)
	DialogueManager.dialogueEnded.connect(_onDialogueEnded)
	_panel.hide()


func _onDialogueStarted(firstLine: String) -> void:
	_panel.show()
	_playLine(firstLine)


func _onLineChanged(line: String) -> void:
	_playLine(line)


func _onDialogueEnded() -> void:
	_panel.hide()
	_dialogueLabel.text = ""
	_speakerLabel.text = ""


func _playLine(line: String) -> void:
	_fullText = line
	_dialogueLabel.text = _fullText
	_dialogueLabel.visible_characters = 0
	_isTyping = true

	var tween := create_tween()
	tween.tween_property(
		_dialogueLabel,
		"visible_characters",
		_fullText.length(),
		_fullText.length() / typewriterSpeed
	).from(0)
	tween.finished.connect(_onTypewriterFinished)


func _onTypewriterFinished() -> void:
	_isTyping = false


func skipTypewriter() -> void:
	_dialogueLabel.visible_characters = -1
	_isTyping = false
