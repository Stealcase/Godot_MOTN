extends Control

var self_viewport : SubViewport 
# Called when the node enters the scene tree for the first time.

var camera : FollowCamera 


func set_world(parent_viewport):
	self_viewport = get_node("SmoothCamContainer/SubViewport")
	self_viewport.world_2d = parent_viewport.world_2d

func set_camera_target(cam_target):
	camera = get_node("SmoothCamContainer/SubViewport/Camera2D")
	var viewport_container = get_node("SmoothCamContainer")
	camera.define_cam_target(cam_target, viewport_container)
