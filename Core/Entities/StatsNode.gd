extends Node
class_name StatsNode

var stats : Stats
var types : Array[ElementalType]
signal health_restored(old_val : int, new_val : int)
signal damage_taken(old_val : int, new_val : int)
signal died

var hp : get = _get_hp
var strength : get = _get_strength 
var defense : get = _get_defense 
var power : get = _get_power 
var fortitude : get = _get_fortitude 
var speed : get = _get_speed

func _get_hp() -> int:
	return stats.hp

func _get_strength() -> int:
	return stats.strength  

func _get_defense() -> int:
	return stats.defense

func _get_power() -> int:
	return stats.power  

func _get_fortitude() -> int:
	return stats.fortitude  

func _get_speed() -> int:
	return stats.speed

func _on_health_zero():
	died.emit()

func _on_damage_changed(old_val : int, new_val : int):
	damage_taken.emit(old_val, new_val)

func _on_health_restored(old_val : int, new_val : int):
	health_restored.emit(old_val, new_val)


func set_base_stats(breed : Breed) -> void:
	stats = breed.stats
	stats.base_hp.reached_zero.connect(_on_health_zero)
	stats.base_hp.increased.connect(_on_health_restored)
	stats.base_hp.decreased.connect(_on_damage_changed)


func take_damage(action : Action):
	var multiplier : float = Calculator.calculate_damage_multiplier(action.type, types)
	var damage = Calculator.calculate_damage(action.value, multiplier)
	var hp_modifier = StatModifier.new_modifier_source(damage, 200, action)
	stats.base_hp.add_modifier(hp_modifier)
	print("Took " + str(damage) + " Damage")
	damage_taken.emit(damage)
	stats.hp -= damage
	if stats.hp <= 0:
		died.emit()
