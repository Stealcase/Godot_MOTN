extends Camera2D
class_name FollowCamera

@onready @export var target : Node2D 
var isSetup: bool = false
# Called when the node enters the scene tree for the first time.
@onready var GameNode : Node2D = get_node("/root/Game")

@onready var smotCamContainer : SubViewportContainer
const game_size := Vector2(320,180)

@onready var window_scale : int = int((GameNode.get_viewport_rect().size / game_size).x)
@onready var actual_pos : Vector2 = global_position
@onready var whole_pixel_pos : Vector2 = global_position

@onready var target_last_pos : Vector2 = global_position


@export var smooth_speed: float
@export var local_offset: Vector2


func define_cam_target(new_target: Node2D, container : SubViewportContainer) -> void:
	smotCamContainer = container
	target = new_target
	isSetup = true

func _physics_process(delta):
	if not isSetup:
		return
	# Get the actual Position of the camera
# Get where the mouse is
	var local_mouse_pos = GameNode.get_local_mouse_position()
#	print(local_mouse_pos)
	var mouse_pos =  local_mouse_pos / window_scale - (game_size/2)
	#Get a position between where the mouse is and the target. 
	actual_pos = lerp(target_last_pos, target.global_position + local_offset + mouse_pos, delta * smooth_speed)
#	actual_pos = lerp(target.global_position, cam_pos, delta*20)
	whole_pixel_pos = actual_pos.round()
#	print("actual_pos: " + str(actual_pos))
#	print("whole_pixel_pos: " + str(whole_pixel_pos))
	var sub_pixel_pos = whole_pixel_pos - actual_pos 
#	print("sub_pixel_pos: " + str(sub_pixel_pos))
	global_position = whole_pixel_pos
	var calculated_pixel =  Vector2(_round_to_nearest_scaled_pixel(sub_pixel_pos.x), _round_to_nearest_scaled_pixel(sub_pixel_pos.y))
#	print("calculated_pixel: " + str(calculated_pixel))
	smotCamContainer.material.set_shader_parameter("cam_offset",calculated_pixel)
	target_last_pos = target.global_position


# The sub_pixel is a number between 0.5 and -0.5.  
func _round_to_nearest_scaled_pixel(sub_pixel: float) -> float:
	# The number might be negative, so we make it unsigned.
	# Not necessary for native window scale, but we do this anyway for more readable code
	var sub_pixel_pos = absf(sub_pixel)
	var sign = float(1)
	if sub_pixel < 0:
		sign = float(-1)
	match window_scale:
		1: #320x180, Native resolution, no sub-pixel camera movement
			return 0.0 
		2: #740x360, 2 sub-pixels per pixel
			if sub_pixel_pos < 0.25:
				return 0.0 
			if sub_pixel_pos < 0.75:
				return 0.5 * sign
			return 1.0 * sign
		3: #960x540 Illegal Resolution, here for posterity, 3 sub-pixels
			if sub_pixel_pos < 0.16666:
				return 0.0
			if sub_pixel_pos < 0.5:
				return 0.333333 * sign
			if sub_pixel_pos < 0.833334:
				return 0.66666 * sign
		4:
			if sub_pixel_pos < 0.0625:
				return 0.0
			if sub_pixel_pos < 0.1875:
				return 0.125 * sign
			if sub_pixel_pos < 0.3125:
				return 0.25 * sign
			if sub_pixel_pos < 0.4375:
				return 0.375 * sign
			return 0.5 * sign
		5:
			if sub_pixel_pos < 0.0625:
				return 0.0
			if sub_pixel_pos < 0.1875:
				return 0.125 * sign
			if sub_pixel_pos < 0.3125:
				return 0.25 * sign
			if sub_pixel_pos < 0.4375:
				return 0.375 * sign
			return 0.5 * sign
		6:
			if sub_pixel_pos < 0.0625:
				return 0.0
			if sub_pixel_pos < 0.1875:
				return 0.125 * sign
			if sub_pixel_pos < 0.3125:
				return 0.25 * sign
			if sub_pixel_pos < 0.4375:
				return 0.375 * sign
			return 0.5 * sign
#			if sub_pixel_pos < 0.125:
#				return 0.0
#			if sub_pixel_pos < 0.375:
#				return 0.25 * sign
#			if sub_pixel_pos < 0.625:
#				return 0.5 * sign
#			if sub_pixel_pos < 0.875:
#				return 0.75 * sign

	# There's a smarter way to do this, but this works
	var sub_pixel_size_1 = 1 / window_scale
	var sub_pixel_size_2 = sub_pixel_size_1 * 2 
	var sub_pixel_size_3 = sub_pixel_size_1 * 3 
	var sub_pixel_size_4 = sub_pixel_size_1 * 4 #1280x720
	var sub_pixel_size_5 = sub_pixel_size_1 * 5
	var sub_pixel_size_6 = sub_pixel_size_1 * 6 #1920x1080
	# Compares all the sizes of pixels
	if sub_pixel_pos < sub_pixel_size_1:
		return 0.0
	if sub_pixel_pos > sub_pixel_size_1 and sub_pixel_pos < sub_pixel_size_2:
		return sub_pixel_size_1 * sign
	if sub_pixel_pos > sub_pixel_size_2 and sub_pixel_pos < sub_pixel_size_3:
		return sub_pixel_size_2 * sign
	if sub_pixel_pos > sub_pixel_size_3 and sub_pixel_pos < sub_pixel_size_4:
		return sub_pixel_size_3 * sign
	if sub_pixel_pos > sub_pixel_size_4 and sub_pixel_pos < sub_pixel_size_5:
		return sub_pixel_size_4 * sign
	if sub_pixel_pos > sub_pixel_size_5 and sub_pixel_pos < sub_pixel_size_6:
		return sub_pixel_size_5 * sign
	if sub_pixel_pos > sub_pixel_size_6:
		return sub_pixel_size_6 * sign
	return 0.0
