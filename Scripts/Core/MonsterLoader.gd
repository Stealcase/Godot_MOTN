extends Node


func _ready():
	load_local_manifest()

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



func load_local_manifest():
	var breedData = load_json_from_data_folder("BreedData.json")
		
func load_local_types():
	var typeData = load_json_from_data_folder("TypeData.json")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func load_breed_manifest(json_breeds : Array):
	for breed in json_breeds:
		print(breed)
#	pass
