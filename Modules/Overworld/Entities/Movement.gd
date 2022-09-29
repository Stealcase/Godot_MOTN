extends CharacterBody2D

class_name Movement


@onready var actor : Actor = $Actor
enum Directions {
	Right,
	Left,
	Up,
	Down,
	UpRight,
	DownRight,
	DownLeft,
	UpLeft
	}
var directionKeys = [
	"Right",
	"Left",
	"Up",
	"Down",
	"UpRight",
	"DownRight",
	"DownLeft",
	"UpLeft"
	]

var facing : Directions


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const TILE_SIZE = 32

var _pixels_per_second: float = 2 * TILE_SIZE
var _step_size: float = 1 / _pixels_per_second

# Count movement progress in distinct integer steps
var _pixels_moved: int = 0
var direction = Vector2.ZERO
var _is_move_input: bool = false
# Accumulator of deltas, aka fractions of seconds, to time movement. 
var _step: float = 0 



func receive_input(dir: Vector2, is_moving: bool):
	direction = dir
	_is_move_input = is_moving
	change_direction(direction)

func _physics_process(delta: float):
	if not _is_move_input: return

	_step += delta

	if _step < _step_size: return
	
	_step -= _step_size
	_pixels_moved += 1
	
	velocity = direction * _pixels_per_second
	if move_and_slide(): #If collision
		#Do thing if collided
		var collided = true # TODO: Delete this

	
	var current_pos = global_position
	current_pos.x = floor(current_pos.x + 0.5)
	current_pos.y = floor(current_pos.y + 0.5)
	global_position = current_pos
	
	# Complete movement, reset counters
	if _pixels_moved >= TILE_SIZE:
		velocity = Vector2.ZERO
		_step = 0
		_pixels_moved = 0


func change_direction(direc: Vector2) -> void:
	var dir = Directions.Up;
	var angle = rad_to_deg(direc.angle()) #s- 90

	if angle >= -23 && angle <= 22:
		dir = Directions.Right
	elif angle >= 158 || angle <= -158:
		dir = Directions.Left
	elif angle <= -68 && angle >= -113:
		dir = Directions.Up
	elif angle >= 68 && angle <= 113:
		dir = Directions.Down
	#Angled Directions
	elif angle < -23 && angle > -68:
		dir = Directions.UpRight
	elif angle > 23 && angle < 68:
		dir = Directions.DownRight
	elif angle > 113 && angle < 158:
		dir = Directions.DownLeft
	elif angle < -113 && angle > -158:
		dir = Directions.UpLeft
	if (dir != facing):
		facing = dir
		actor.o_animator.play(directionKeys[facing])


func _on_hurtbox_area_entered(area : Area2D):
	print("Collided")
	var other_collision = area.get_parent()
	if other_collision.actor.party != actor.party:
		enter_battle.emit(self,other_collision)
		#	var nodes_in_group = get_tree().get_nodes_in_group(party_name)
#	if other_collision in nodes_in_group:
#		print("Collided with other party member")
#		pass
#	else:
signal enter_battle(self_actor, other_actor)
