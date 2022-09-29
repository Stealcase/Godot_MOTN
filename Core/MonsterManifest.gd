extends Node

class_name MonsterManifest

var monster_loader : IMonsterLoader
@export var use_local_data : bool = true

var breeds: Array[Breed]
var types : Array[ElementalType]
var actions : Array[Action]
var sprite_manifest : Array[MonsterTexture]


func load_manifest():
	if use_local_data:
		monster_loader = LocalMonsterLoader.new()
		breeds = monster_loader.load_breed_data()
		sprite_manifest = monster_loader.load_sprite_data(breeds)
		types = monster_loader.load_type_data()
		actions = monster_loader.load_action_data(types)

func get_random_actions(number_of_actions : int) -> Array[Action]:
	if number_of_actions >= len(actions):
		number_of_actions = len(actions) -1
	var random = RandomNumberGenerator.new()
	random.randomize()
	var chosen_moves : Array[Action] = [] 
	for i in range(0,number_of_actions):
		var index = random.randi_range(0,len(actions)-1)
		chosen_moves.append(actions[index])
	return chosen_moves
