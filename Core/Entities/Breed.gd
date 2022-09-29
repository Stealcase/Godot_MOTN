extends RefCounted
class_name Breed


# (optional) icon to show in the editor dialogs:
@icon("res://icon.svg")


var id : int 
var name : String
var codex_description : String
var stats : Stats
#var leveling_tier :  int  #TODO: Implement in data
#var xpGain : int  # TODO: Implement in data
var types : Array[int] #int array #TODO: Get actions from breeds
var actions :  Array[int]

var visual_description : String

#var col = Color.white :  Color 
#var  Rules :  Rule[]

func _init(breed : Dictionary):
	id = breed["id"]
	name = breed["name"]
	visual_description = breed["visualDescription"]
	stats = Stats.new(breed)
#	leveling_tier = breed["leveling_tier"]
#	xpGain = breed["xpGain"]
	types = breed["types"]
#	actions = breed["actions"] #TODO: Actions arent gotten from Breed yet
