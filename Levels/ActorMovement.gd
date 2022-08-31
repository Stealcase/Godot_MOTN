extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const TILE_SIZE = 32

var _pixels_per_second: float = 2 * TILE_SIZE
var _step_size: float = 1 / _pixels_per_second

# Count movement progress in distinct integer steps
var _pixels_moved: int = 0


# Accumulator of deltas, aka fractions of seconds, to time movement. 
var _step: float = 0 

var direction = Vector2.ZERO
var _is_move_input: bool = false

func receive_input(dir: Vector2, is_moving: bool):
	direction = dir
	_is_move_input = is_moving

func _physics_process(delta: float):
	if not _is_move_input: return

	_step += delta

	if _step < _step_size: return
	
	_step -= _step_size
	_pixels_moved += 1
	
	velocity = direction * _pixels_per_second
	if move_and_slide(): #If collision
		#Do thing if collided
		print("Collision")

	
	var current_pos = global_position
	current_pos.x = floor(current_pos.x + 0.5)
	current_pos.y = floor(current_pos.y + 0.5)
	global_position = current_pos
	
	# Complete movement, reset counters
	if _pixels_moved >= TILE_SIZE:
		velocity = Vector2.ZERO
		_step = 0
		_pixels_moved = 0

	#velocity.y = move_toward(velocity.y, 0, SPEED)


#func _unhandled_input(event: InputEvent) -> void:
#	var input_vector = Vector2.ZERO 
#
#	input_vector.y += event.get_action_strength("move_down")
#	input_vector.y -= event.get_action_strength("move_up")
#	input_vector.x += event.get_action_strength("move_right")
#	input_vector.x -= event.get_action_strength("move_left")
#	#if input_vector != Vector2.ZERO:
#		#input_vector = input_vector.normalized()
#	direction = input_vector
