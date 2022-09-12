extends Node

class_name MonsterManifest

@export var use_local_data : bool = true

var breeds: Array
var types : Array
var moves : Array
var sprite_manifest

func _ready():
	if use_local_data:
		breeds = $MonsterLoader.load_local_breed_data()
		load_monsters(breeds)
		types = $MonsterLoader.load_local_types()
		moves = $MonsterLoader.load_local_moves()
	
func load_monsters(breeds : Array):
	sprite_manifest = $MonsterLoader.load_local_manifest(breeds)
	var random = RandomNumberGenerator.new()
	for mon in sprite_manifest:
		var sprite = AnimatedSprite2D.new()
		sprite.frames = mon.o_anim
		sprite.name = mon.mon_name + "_img"
		add_child(sprite)
		sprite.play("Front")
		sprite.position = Vector2(random.randi_range(-200,200), random.randi_range(-200,200))
