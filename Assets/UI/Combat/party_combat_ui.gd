class_name partyUI
extends Control

const button = preload("res://Assets/UI/Combat/menu_button.tscn")
var offsets = {
	"top": Vector2(0, -20),
	"right": Vector2(20, 0),
	"bottom": Vector2(0, 20),
	"left": Vector2(-20, 0),
	"center": Vector2.ZERO
}

@export var backIcon: Texture2D
@onready var ATBall: TextureProgressBar = $ATBall
@onready var CombatTree: Node2D = $CombatTree

func _ready() -> void:
	CombatTree.hide()

func updateATB(ATB: int) -> void:
	
	ATBall.value = ATB

func activateMenu() -> void:
	
	ATBall.hide()
	CombatTree.show()

func openAbilities(abilities: Array[Ability]) -> void:
	
	CombatTree.hideRoot()
	
	var bottomButton: menuButton = button.instantiate()
	CombatTree.add_child(bottomButton)
	bottomButton.init(abilities[0].icon)
	bottomButton.position = offsets["bottom"]
	
	var leftButton: menuButton = button.instantiate()
	CombatTree.add_child(leftButton)
	bottomButton.init(abilities[1].icon)
	bottomButton.position = offsets["left"]
	
	var topButton: menuButton = button.instantiate()
	CombatTree.add_child(topButton)
	bottomButton.init(abilities[2].icon)
	bottomButton.position = offsets["top"]
	
	var rightButton: menuButton = button.instantiate()
	CombatTree.add_child(rightButton)
	bottomButton.init(backIcon)
	bottomButton.position = offsets["right"]
	
