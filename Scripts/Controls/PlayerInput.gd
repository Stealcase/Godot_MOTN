extends Node

var player_input = Vector2.ZERO
var direction = Vector2.ZERO
var _is_move_input: bool = false

@export 
var playerMovement : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	player_input.x = Input.get_axis("move_left", "move_right")
	player_input.y = Input.get_axis("move_up", "move_down")
#	if player_input != Vector2.ZERO:
#		player_input = player_input.normalized()
	if player_input != Vector2.ZERO:
		_is_move_input = true
		direction = player_input.normalized()
	else:
		_is_move_input = false
	
	#Are we moving?
	playerMovement.receive_input(direction, _is_move_input)
