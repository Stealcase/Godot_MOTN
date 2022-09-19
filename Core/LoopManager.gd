extends Node

var monster_prefab = preload("res://Core/Entities/Monster.tscn")
var player_input = preload("res://Core/Input/PlayerInput.tscn")
var camera = preload("res://Core/FollowCam.tscn")

var isHeadless : bool = false

@onready var target = get_node("/root/Game/GameViewportScale/SmoothCamContainer/SubViewport")
# Starting point for a new game session. 
# Loads Manifest, Instances monsters, sets up player, etc.
func _ready():
#	_generate_map()
	$Manifest.load_manifest()
	var random = RandomNumberGenerator.new()
	for mon in $Manifest.sprite_manifest:
		var monster_instance = monster_prefab.instantiate()
		var sprite = monster_instance.get_node("O_Animator")
		monster_instance.name = mon.mon_name
		sprite.frames = mon.o_anim
		target.add_child(monster_instance)
		sprite.play("Front")
		monster_instance.position = Vector2(random.randi_range(-200,200), random.randi_range(-200,200))
		if mon.id == 0:
			var playerInput = player_input.instantiate()
			monster_instance.add_child(playerInput)
			playerInput.setup_input(monster_instance)
			var cam = camera.instantiate()
			cam.set_target(monster_instance)
			target.add_child(cam)

#func _generate_map():
	# Later add functionality to generate maps
	#var map = get_node("/root/Game/TileMap")
	#target.add_child(map)
	
	



