extends RefCounted

#Interface for monster loaders.
class_name IMonsterLoader

func load_sprite_data(breeds : Array[Breed]) -> Array[MonsterTexture]:
	var monster_array : Array[MonsterTexture]  = []
	return monster_array
		
		
func load_breed_data() -> Array[Breed]:
	var breed_array : Array[Breed]  = []
	return breed_array
	
func load_type_data() -> Array[ElementalType]:
	var elemental_type : Array[ElementalType]  = []
	return elemental_type

func load_action_data(types : Array[ElementalType]) -> Array[Action]:
	var action_data : Array[Action] = []
	return action_data
