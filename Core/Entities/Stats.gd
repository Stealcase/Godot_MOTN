extends RefCounted

class_name Stats

var base_hp : Stat 
var base_strength : Stat 
var base_defense : Stat
var base_power : Stat
var base_fortitude : Stat 
var base_speed : Stat

var level : int = 1
var xp : int = 0

var hp : get = _get_hp
var strength : get = _get_strength 
var defense : get = _get_defense 
var power : get = _get_power 
var fortitude : get = _get_fortitude 
var speed : get = _get_speed

var growth_hp : int
var growth_strength : int
var growth_defense : int
var growth_fortitude : int
var growth_power : int
var growth_speed : int

func _get_hp() -> int:
	return base_hp.Value

func _get_strength() -> int:
	return base_strength.Value  

func _get_defense() -> int:
	return base_defense.Value

func _get_power() -> int:
	return base_power.Value  

func _get_fortitude() -> int:
	return base_fortitude.Value  

func _get_speed() -> int:
	return base_speed.Value

func calculate_growth(_level :int, base_stat : int, growth_stat : float) -> int:
	return base_stat + floori(_level * growth_stat)


func _init(breed : Dictionary):
	base_hp = Stat.new(breed["hp"])
	base_strength = Stat.new(breed["strength"])
	base_defense = Stat.new(breed["defense"])
	base_power = Stat.new(breed["power"])
	base_fortitude = Stat.new(breed["fortitude"])
	base_speed = Stat.new(breed["speed"])
	
	growth_hp = breed["growthHp"]
	growth_strength = breed["growthStrength"]
	growth_defense = breed["growthDefense"]
	growth_fortitude = breed["growthFortitude"]
	growth_power = breed["growthPower"]
	growth_speed = breed["growthSpeed"]


