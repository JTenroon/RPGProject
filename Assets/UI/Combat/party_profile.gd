extends TextureRect

@onready var HPBar: TextureProgressBar = $"HP Bar"
@onready var MPBar: TextureProgressBar = $"MP Bar"
@onready var Portrait: TextureRect = $"CombatPortrait"
@onready var HPCount: Label = $"HP Count"
@onready var MPCount: Label = $"MP Count"

func _ready():
	
	MPBar.max_value = 0.0
	HPBar.max_value = 0.0
	MPBar.value = 0.0
	HPBar.value = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func init (member : CharacterBody2D):
	
	HPBar.max_value = member.stats.currentMaxHP
	MPBar.max_value = member.stats.currentMaxMP
	
	HPBar.value = member.currentHP
	MPBar.value = member.currentMP
	
	
