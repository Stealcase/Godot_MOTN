extends Node

var monster_prefab = preload("res://Core/Entities/Actor.tscn")
var battle_node = preload("res://Core/Battle/Battle.tscn")
var party_prefab = preload("res://Core/Party.tscn")


#TODO: Player dependencies. These can be refactored out
var player_input = preload("res://Core/Input/PlayerInput.tscn")
var ai_brain = preload("res://Core/Input/AIBrain.tscn")
#var camera = preload("res://Modules/Overworld/Camera/PlayerOverworldViewport.tscn")

@onready var game = get_node("/root/Main")
var isHeadless : bool = false

@onready var viewport = get_node("/root/Main/SubViewportContainer/SubViewport")
@onready var manifest : MonsterManifest = get_node("Manifest")
# Starting point for a new game session. 
# Loads Manifest, Instances monsters, sets up player, etc.
	
func _ready():
#	_generate_map()
	manifest.load_manifest()
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	for i in range(0, len(manifest.sprite_manifest)):
		var monster_instance : Actor = monster_prefab.instantiate()
		var sprite = monster_instance.get_node("B_Animator")
		monster_instance.breed = manifest.breeds[manifest.sprite_manifest[i].id]
		monster_instance.position = Vector2(i * 64, 64)
		monster_instance.name = manifest.sprite_manifest[i].mon_name
		sprite.add_child(manifest.sprite_manifest[i])
		sprite.frames = manifest.sprite_manifest[i].b_anim
		var stats = monster_instance.get_node("Stats")
		stats.set_base_stats(manifest.breeds[manifest.sprite_manifest[i].id])
		game.call_deferred("add_child", monster_instance)
		monster_instance.actions = manifest.get_random_actions(4)
		var party_index = i % 4 
		var party_instance : Party
		if party_index == 0:
			party_instance = party_prefab.instantiate()
			party_instance.name = str(manifest.sprite_manifest[i].mon_name) + "_" + str(random.randi())
			$Parties.add_child(party_instance)
			var aiBrain = ai_brain.instantiate()
			aiBrain.setup_target(party_instance)
			party_instance.add_child(aiBrain)

		party_instance.add(monster_instance)
	
	call_deferred("start_battle")
		#TODO: Player dependencies. These can be refactored out:
#		if manifest.sprite_manifest[i].id == 0:
#			var playerBrain = player_input.instantiate()
#			monster_instance.add_child(playerBrain)
#			playerBrain.setup_input(monster_instance)
#			var player_viewport = camera.instantiate()

#			player_viewport.set_world(overworld_Viewport)
#			player_viewport.set_camera_target(monster_instance)
#			game.call_deferred("add_child", player_viewport)
#		else:

func start_battle() -> void:
	var party = $Parties.get_child(1)
	party.visualize_battle = true
	var party2 = $Parties.get_child(2)
	var battle_instance = battle_node.instantiate()
	$Battles.add_child(battle_instance)
	battle_instance.enter_battle(party.active_actor, party2.active_actor)


var actors_looking_to_fight :Dictionary = {}
