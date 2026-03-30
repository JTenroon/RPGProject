class_name Ability

extends Resource

enum actionAnimation {DASH,CAST,SINGLE,SPIN,JUMP,COMBO}
enum type {NEUTRAL,FIRE,ICE,BOLT,WIND,EARTH,DENDRO,WATER,WEIRD,LIGHT,DARK}

@export var actionName: String = ""
@export var icon: Texture2D
@export var power: int
@export var mpCost: int
@export var speed: float
@export var particleFX: PackedScene
@export var animation: actionAnimation
@export var multiTarget: bool
@export var isMagic: bool
@export var element: type
