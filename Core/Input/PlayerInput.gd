extends Node

var player_input = Vector2.ZERO
var direction = Vector2.ZERO
var _is_move_input: bool = false

@export 
var playerMovement : CharacterBody2D

var isSetup: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if playerMovement: 
		isSetup = true

func setup_input(controller: CharacterBody2D):
	playerMovement = controller
	isSetup = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if isSetup:
		player_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#	if player_input != Vector2.ZERO:
	#		player_input = player_input.normalized()
		if player_input != Vector2.ZERO:
			_is_move_input = true
			direction = player_input.normalized()
		else:
			_is_move_input = false
		
		#Are we moving?
		playerMovement.receive_input(direction, _is_move_input)

#func _input(event: InputEventAction):
