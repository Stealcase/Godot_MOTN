extends Node

class_name MonsterManifest

@export var use_local_data : bool = true

var breeds: Array
var types : Array
var moves : Array
var sprite_manifest

var monster_prefab = preload("res://Core/Entities/Monster.tscn")

func _ready():
	if use_local_data:
		breeds = $MonsterLoader.load_local_breed_data()
		load_monsters(breeds)
		types = $MonsterLoader.load_local_types()
		moves = $MonsterLoader.load_local_moves()
	
func load_monsters(breeds : Array):
	var monster = load("res://Core/Entities/Monster.tscn")
	sprite_manifest = $MonsterLoader.load_local_manifest(breeds)
	var random = RandomNumberGenerator.new()
	for mon in sprite_manifest:
		var monster_instance = monster_prefab.instantiate()
		var sprite = monster_instance.get_node("O_Animator")
		monster_instance.name = mon.mon_name
		sprite.frames = mon.o_anim
		add_child(monster_instance)
		sprite.play("Front")
		monster_instance.position = Vector2(random.randi_range(-200,200), random.randi_range(-200,200))
