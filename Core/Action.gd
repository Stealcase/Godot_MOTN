extends RefCounted

class_name Action

var id: int
var name : String
var type : ElementalType
var value : int
var characteristic : int
var flags : Array[String]
var description : String


func _init(action_dict : Dictionary, types : Array[ElementalType]):
	id = action_dict["id"]
	name = action_dict["name"]
	type = types[action_dict["type"]] #Get the type based on type index
	value = action_dict["value"]
	characteristic = action_dict["characteristic"]
#	flags = action_dict["flags"]
	description = action_dict["description"]
