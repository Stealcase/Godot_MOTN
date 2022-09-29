extends Node

var monster_prefab = preload("res://Modules/Overworld/Entities/Monster.tscn")
var battle_node = preload("res://Core/Battle/Battle.tscn")
var party_prefab = preload("res://Core/Party.tscn")


#TODO: Player dependencies. These can be refactored out
var player_input = preload("res://Core/Input/PlayerInput.tscn")
var ai_brain = preload("res://Core/Input/AIBrain.tscn")
var camera = preload("res://Modules/Overworld/Camera/PlayerOverworldViewport.tscn")

@onready var game = get_node("/root/Main")
var isHeadless : bool = false

@onready var overworld_Viewport = get_node("/root/Main/OverworldViewport/SubViewport")
@onready var manifest : MonsterManifest = get_node("Manifest")
# Starting point for a new game session. 
# Loads Manifest, Instances monsters, sets up player, etc.
func _ready():
#	_generate_map()
	manifest.load_manifest()
	var random = RandomNumberGenerator.new()
	random.randomize()
	for mon in manifest.sprite_manifest:
		var monster_instance = monster_prefab.instantiate()
		var sprite = monster_instance.get_node("Actor/O_Animator")
		monster_instance.name = mon.mon_name
		sprite.frames = mon.o_anim
		overworld_Viewport.add_child(monster_instance)
		var stats = monster_instance.get_node("Actor/Stats") as StatsNode
		stats.set_base_stats(manifest.breeds[mon.id])
		sprite.play("Front")
		monster_instance.position = Vector2(random.randi_range(-200,200), random.randi_range(-200,200))
		monster_instance.actor.actions = manifest.get_random_actions(4)
		monster_instance.enter_battle.connect(_on_battle_trigger)
		var party_instance = party_prefab.instantiate()
		party_instance.name = str(mon.mon_name) + "_" + str(random.randi())
		$Parties.add_child(party_instance)
		party_instance.add(monster_instance.actor)
		#TODO: Player dependencies. These can be refactored out:
		if mon.id == 0:
			var playerBrain = player_input.instantiate()
			monster_instance.add_child(playerBrain)
			playerBrain.setup_input(monster_instance)
			var player_viewport = camera.instantiate()
			
			player_viewport.set_world(overworld_Viewport)
			player_viewport.set_camera_target(monster_instance)
			game.call_deferred("add_child", player_viewport)
		else:
			var aiBrain = ai_brain.instantiate()
			aiBrain.setup_target(party_instance)


var actors_looking_to_fight :Dictionary = {}


func _on_battle_trigger(self_actor, other_actor):
	#Add actor to
	actors_looking_to_fight[self_actor] = other_actor 
	#Check if someone already has added the actor
	if other_actor in actors_looking_to_fight:
		if actors_looking_to_fight[other_actor] == self_actor:
			print("Start a fight!")
			actors_looking_to_fight.erase(self_actor)
			actors_looking_to_fight.erase(other_actor)
			
			var battle_instance = battle_node.instantiate()
			$Battles.add_child(battle_instance)
			battle_instance.enter_battle(self_actor.actor, other_actor.actor)

#func _generate_map():
	# Later add functionality to generate maps
	#var map = get_node("/root/Game/TileMap")
	#target.add_child(map)
	
	



