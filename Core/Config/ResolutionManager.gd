extends Control

@onready var viewport : Viewport = get_node("/root") 
@onready var gameViewportScale : Control = get_node("/root/Game/OverworldViewport")
const game_size := Vector2i(320,180)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _change_resolution(i: int):
	print("Old Size: " + str(viewport.size))
	match i:
		1: #320x180, base resoltion
			viewport.size = game_size
		2:
			viewport.size = game_size * i
		3: 
			viewport.size = game_size * i
		4: 
			viewport.size = game_size * i
		5: 
			viewport.size = game_size * i
		6: 
			viewport.size = game_size * i
	print("New Size: " + str(viewport.size))
	gameViewportScale.scale.x = i
	gameViewportScale.scale.y = i

#func _fullscreen():
#	OS
	
func _on_button_pressed(extra_arg_0 : int):
	_change_resolution(extra_arg_0)
