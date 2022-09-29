extends RefCounted
class_name ElementalType

var id : int
var name : String
var weakness : Array[int]
var resistance : Array[int]
var immune : Array[int]
var description : String


func _init(type_dict : Dictionary):
	id = type_dict["id"]
	name = type_dict["name"]
	weakness = type_dict["weakness"]
	resistance = type_dict["resistance"]
	immune = type_dict["immune"]
	description = type_dict["description"]
