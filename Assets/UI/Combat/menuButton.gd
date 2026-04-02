class_name menuButton

extends TextureRect

@export var icon: Texture2D
@onready var rect: TextureRect = $icon

func _ready() -> void:
	if icon:
		rect.texture = icon
