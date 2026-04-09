class_name partyUI
extends Control

const button = preload("res://Assets/UI/Combat/menu_button.tscn")
var offsets = {
	"top": Vector2(-10, -40),
	"right": Vector2(20, -7),
	"bottom": Vector2(-10, 27),
	"left": Vector2(-40, -7),
	"center": Vector2(-10,-7)
}

@export var backIcon: Texture2D
@export var attackIcon: Texture2D
@export var magicIcon: Texture2D
@export var itemIcon: Texture2D
@export var defendIcon: Texture2D
@export var cursorIcon: Texture2D

@onready var ATBall: TextureProgressBar = $ATBall
@onready var CombatTree: Node2D = $CombatTree

func updateATB(ATB: int) -> void:
	
	ATBall.value = ATB

func activateMenu() -> void:
	
	#eventually tween ATBall to center
	buildRoot()
	
func buildRoot() -> void:

	ATBall.hide()
	#eventually all buttons start at center to tween out to positions
	var magicButton: menuButton = button.instantiate()
	CombatTree.add_child(magicButton)
	magicButton.init(magicIcon)
	magicButton.position = offsets["bottom"]
	
	var attackButton: menuButton = button.instantiate()
	CombatTree.add_child(attackButton)
	attackButton.init(attackIcon)
	attackButton.position = offsets["left"]
	
	var itemButton: menuButton = button.instantiate()
	CombatTree.add_child(itemButton)
	itemButton.init(itemIcon)
	itemButton.position = offsets["top"]
	
	var defendButton: menuButton = button.instantiate()
	CombatTree.add_child(defendButton)
	defendButton.init(defendIcon)
	defendButton.position = offsets["right"]

func openAbilities(abilities: Array[Ability]) -> void:
	
	clearButtons()
	
	#start from center to tween to positions
	var bottomButton: menuButton = button.instantiate()
	CombatTree.add_child(bottomButton)
	bottomButton.init(abilities[0].icon)
	bottomButton.position = offsets["bottom"]
	
	var leftButton: menuButton = button.instantiate()
	CombatTree.add_child(leftButton)
	leftButton.init(abilities[1].icon)
	leftButton.position = offsets["left"]
	
	var topButton: menuButton = button.instantiate()
	CombatTree.add_child(topButton)
	topButton.init(abilities[2].icon)
	topButton.position = offsets["top"]
	
	var rightButton: menuButton = button.instantiate()
	CombatTree.add_child(rightButton)
	rightButton.init(backIcon)
	rightButton.position = offsets["right"]

func openCursor() -> void:
	var cursorRect:TextureRect = TextureRect.new()
	
	cursorRect.texture = cursorIcon
	CombatTree.add_child(cursorRect)
	cursorRect.position = offsets["top"]
	
	
func cycleRestart() -> void:

	ATBall.show()
	clearButtons()

func menuBack() -> void:
	clearButtons()
	buildRoot()

func clearButtons() -> void:
	for child in CombatTree.get_children():
		child.queue_free()
