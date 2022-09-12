extends Node

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

	
func load_local_manifest(breeds : Array):
	var manifest = []
	for breed in breeds:
		var monTex = MonsterTexture.new()
		monTex.mon_name = breed["name"]
		monTex.b_mon = _load_monster(breed["name"], ImageType.Battle)
		monTex.o_mon = _load_monster(breed["name"], ImageType.Overworld)
		print(breed["name"])
		monTex.generate_animations()
		manifest.append(monTex)
	return manifest
		
		
func load_local_breed_data():
	return load_json_from_data_folder("BreedData.json")["breeds"]
	
func load_local_types():
	var typeData = load_json_from_data_folder("TypeData.json")["types"]
	return typeData

func load_local_moves():
	var typeData = load_json_from_data_folder("MoveData.json")["actions"]
	return typeData
