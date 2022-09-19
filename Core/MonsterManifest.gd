extends Node

class_name MonsterManifest

@export var use_local_data : bool = true

var breeds: Array
var types : Array
var moves : Array
var sprite_manifest


func load_manifest():
	if use_local_data:
		breeds = $MonsterLoader.load_local_breed_data()
		_load_monsters(breeds)
		types = $MonsterLoader.load_local_types()
		moves = $MonsterLoader.load_local_moves()
	
func _load_monsters(breeds : Array):
	var monster = load("res://Core/Entities/Monster.tscn")
	sprite_manifest = $MonsterLoader.load_local_manifest(breeds)
	
