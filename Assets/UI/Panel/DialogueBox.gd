extends CanvasLayer

@export var typewriterSpeed: float = 30.0

@onready var _panel: Panel = $Panel
@onready var _speakerLabel: Label = $Panel/NameLabel
@onready var _dialogueLabel: Label = $Panel/BodyText

var _fullText: String = ""
var _isTyping: bool = false
var _tween: Tween



func _ready() -> void:
	
	self.show()
	print("panel is: ", _panel)
	DialogueManager.dialogueStarted.connect(_onDialogueStarted)
	DialogueManager.lineChanged.connect(_onLineChanged)
	DialogueManager.dialogueEnded.connect(_onDialogueEnded)
	_panel.hide()


func _onDialogueStarted(speakerName: String, firstLine: String) -> void:
	print("Do you see the text?")
	_speakerLabel.text = speakerName
	_panel.show()
	_playLine(firstLine)


func _onLineChanged(line: String) -> void:
	_playLine(line)


func _onDialogueEnded() -> void:
	print ("dialog's over bro ")
	_panel.hide()
	_dialogueLabel.text = ""
	_speakerLabel.text = ""


func _playLine(line: String) -> void:
	_fullText = line
	_dialogueLabel.text = _fullText
	_dialogueLabel.visible_characters = 0
	_isTyping = true

	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(
		_dialogueLabel,
		"visible_characters",
		_fullText.length(),
		_fullText.length() / typewriterSpeed
	).from(0)
	_tween.finished.connect(_onTypewriterFinished)


func _onTypewriterFinished() -> void:
	_isTyping = false


func skipTypewriter() -> void:
	if _tween:
		_tween.kill()
	_dialogueLabel.visible_characters = -1
	_isTyping = false
