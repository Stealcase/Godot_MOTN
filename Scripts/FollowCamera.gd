extends Camera2D

@onready @export
var player : CharacterBody2D = get_node("../PlayerChar")

# Called when the node enters the scene tree for the first time.
@onready @export 
var GameNode : Node2D = get_node("/root/Game")

@onready @export 
var smotCamContainer : SubViewportContainer = get_node("/root/Game/ViewPort_Scale&Size/SmoothCamContainer")
const game_size := Vector2(384,216)

@onready
var window_scale : float = (GameNode.get_viewport_rect().size / game_size).x
@onready
var actual_pos : Vector2 = global_position
@onready
var whole_pixel_pos : Vector2 = global_position

@onready
var player_last_pos : Vector2 = global_position

@export
var smooth_speed: float
@export
var local_offset: Vector2

func _ready():
	
	print(GameNode.get_viewport_rect().size)
	print(window_scale)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process_(delta):
	

func _physics_process(delta):
	# Get the actual Position of the camera
# Get where the mouse is
	var mouse_pos =  GameNode.get_local_mouse_position() / window_scale - (game_size/2) + player.global_position
	#Get a position between where the mouse is and the player. 
	actual_pos = lerp(player_last_pos, player.global_position + local_offset, delta * smooth_speed)
#	actual_pos = lerp(player.global_position, cam_pos, delta*20)
	whole_pixel_pos = actual_pos.round()
	var sub_pixel_pos = whole_pixel_pos - actual_pos
	global_position = whole_pixel_pos
	smotCamContainer.material.set_shader_parameter("cam_offset", sub_pixel_pos)
	player_last_pos = player.global_position
