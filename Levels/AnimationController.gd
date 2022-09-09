extends AnimatedSprite2D

@export
var monsterName = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://Monsters/" + monsterName + "/B_" + monsterName + "_mon.json", File.READ)
#	var data = parse_json(file.get_as_text())
#	file_data = data

var battle_img = load("res://Monsters/" + monsterName + "/B_" + monsterName + "_mon.png")
var overworld_img = load("res://Monsters/" + monsterName + "/O_" + monsterName + "_mon.png")

var battle_json = load("res://Monsters/" + monsterName + "/B_" + monsterName + "_mon.json")
var overworld_json = load("res://Monsters/" + monsterName + "/O_" + monsterName + "_mon.json")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
