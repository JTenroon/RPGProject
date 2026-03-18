extends CharacterBody2D

# -- Stats (later these can come from a CharacterStats resource) --
@export var moveSpeed: float = 300.0
@export var HP: int = 25
@export var ATK: int = 5
@export var SPD: int = 5



var movementDisabled = false
var _lastDir: Vector2

#sets up variables for all child nodes that will be referred to throughout the player script
var animTree: AnimationTree 
var pointer: RayCast2D
var talkIcon: Sprite2D
var examineIcon: Sprite2D

# -- Internal state --
var _inputDirection: Vector2 = Vector2.ZERO

func _ready() -> void:
	pointer = $pointer
	talkIcon = $talkIcon
	examineIcon = $examineIcon
	_lastDir = Vector2.DOWN
	animTree = $AnimationTree

func _physics_process(delta: float) -> void:
	_handleInput()
	_applyMovement()
	_animate()
	_updateContext()
	

func _handleInput() -> void:
	
	if Input.is_action_just_pressed("disableMovement"):
		if !movementDisabled:
			movementDisabled = true
			print("movement disabled")
		else:
			movementDisabled = false
			print("movement enabled") 
			
	if Input.is_action_just_pressed("context"):
		_interact()
		
	# Input.get_vector() reads the input map and returns a normalized direction vector
	# It automatically handles diagonal movement normalization and deadzone for analog sticks
	if !movementDisabled:
		_handleDir()

func _handleDir():
	
	#reads player input
	_inputDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#determines the direction of player character for pointer and animation purposes.
	#direction will only update when one direction is dominant 
	#ie.for diagonal inputs, the direction will be whatever axis is detected first.
	if _inputDirection != Vector2.ZERO:
		if abs(_inputDirection.x) > abs(_inputDirection.y):
			_lastDir = Vector2(sign(_inputDirection.x), 0)
		elif abs(_inputDirection.y) > abs(_inputDirection.x):
			_lastDir = Vector2(0, sign(_inputDirection.y))

func _interact() -> void:
	print("it's sensitive to context")
	if GameState.currentState == GameState.State.DIALOGUE:
		var dialogueBox := get_node("/root/Main/DialogueBox")
		if dialogueBox._isTyping:
			dialogueBox.skipTypewriter()
		else:
			DialogueManager.advance()
		return

	if pointer.is_colliding():
		var collider := pointer.get_collider()
		var interactable: Node = collider.get_node_or_null("Interactable")
		if interactable:
			interactable.interact()
	

func _applyMovement() -> void:

	velocity = _inputDirection * moveSpeed
	if movementDisabled:	
		velocity = Vector2.ZERO

	move_and_slide()
		
func _animate() -> void:
	
	if _inputDirection != Vector2.ZERO:
		animTree["parameters/conditions/running"] = true
		animTree["parameters/conditions/idle"] = false
		animTree["parameters/Run/blend_position"] = _lastDir
	else:
		animTree["parameters/conditions/idle"] = true
		animTree["parameters/conditions/running"] = false
		animTree["parameters/Idle/blend_position"] = _lastDir
		
	
	
	
func _updateContext() -> void:
	
	pointer.target_position = _lastDir.normalized() * 50.0
	
	if pointer.is_colliding():
		if pointer.get_collider().is_in_group("talkable"):
			talkIcon.show()
	else:
		talkIcon.hide()
		examineIcon.hide()
