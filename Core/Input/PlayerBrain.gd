extends Brain

class_name PlayerBrain

func _init():
	brain_type = ControllerSource.Player #PlayerBrain
	

@export 
var playerMovement : CharacterBody2D

var isSetup: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if playerMovement: 
		isSetup = true
		
func setup_target(_party : Party):
	super(setup_target(_party)) #Call base class
	pass

func setup_input(controller: CharacterBody2D):
	playerMovement = controller
	isSetup = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if isSetup:
		direction_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#	if player_input != Vector2.ZERO:
	#		player_input = player_input.normalized()
		if direction_input != Vector2.ZERO:
			_is_move_input = true
			direction = direction_input.normalized()
		else:
			_is_move_input = false
		
		#Are we moving?
		playerMovement.receive_input(direction, _is_move_input)

#func _input(event: InputEventAction):
