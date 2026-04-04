class_name menuButton

extends TextureRect

@onready var rect:TextureRect = $Icon
@export var icon: Texture2D

func _ready() -> void:
	if icon: 
		rect.texture = icon

func init(pic: Texture2D) -> void:
	rect.texture = pic
