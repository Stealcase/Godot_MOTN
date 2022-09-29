extends IMonsterLoader

class_name LocalMonsterLoader

enum ImageType {
	Overworld,
	Battle
	}
	
func load_json_from_data_folder(filename: String):
	var file = File.new()
	var json = JSON.new()
	file.open("res://Data/" + filename, File.READ)
	var string_data = file.get_as_text()
	var data = json.parse(string_data)
	if data == OK:
		var data_received = json.get_data()
		match typeof(data_received):
			TYPE_ARRAY:
				print("Got Array")
			TYPE_DICTIONARY:
				print("Dictionary")
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", string_data, " at line ", json.get_error_line())

func _load_monster(monsterName: String, imgType : ImageType) -> MonsterImageHandler:
	var prefix = "/B_"
	match(imgType):
		ImageType.Overworld:
			prefix = "/O_"
		ImageType.Battle:
			prefix = "/B_"
			
	var file = File.new()
	file.open("res://Assets/Monsters/" + monsterName + prefix + monsterName + "_mon.json", File.READ)
	var mon_string = file.get_as_text()
	file.close()
	var mon_img = Image.load_from_file("res://Assets/Monsters/" + monsterName + prefix + monsterName + "_mon.png")
	
	var res = MonsterImageHandler.new()
	res.tex = ImageTexture.create_from_image(mon_img)
	res.data = JSON.parse_string(mon_string)
	res.generate_frames()
	return res

func load_sprite_data(breeds : Array[Breed]) -> Array[MonsterTexture]:
	var sprite_data : Array[MonsterTexture] = []
	for breed in breeds:
		var monTex = MonsterTexture.new()
		monTex.mon_name = breed["name"]
		monTex.b_mon = _load_monster(breed["name"], ImageType.Battle)
		monTex.o_mon = _load_monster(breed["name"], ImageType.Overworld)
		monTex.id = breed.id
		print(breed["name"])
		monTex.generate_animations()
		sprite_data.append(monTex)
	return sprite_data
		
		
func load_breed_data() -> Array[Breed]:
	var breed_array : Array[Breed] = []
	var json_dict = load_json_from_data_folder("BreedData.json")
	for breed in json_dict["breeds"]:
		breed_array.append(Breed.new(breed))
	return breed_array
	
func load_type_data() -> Array[ElementalType]:
	var typeData : Array[ElementalType] = []
	var json_dict = load_json_from_data_folder("TypeData.json")
	for type_data in json_dict["types"]:
		typeData.append(ElementalType.new(type_data))
	return typeData

func load_action_data(types : Array[ElementalType]) -> Array[Action]:
	var action_data : Array[Action] = []
	var json_dict = load_json_from_data_folder("MoveData.json")
	for action in json_dict["actions"]:
		action_data.append(Action.new(action, types))
	return action_data
