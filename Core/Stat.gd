extends RefCounted
class_name Stat

#Public facing values
var Value : get = _get_stat
var StatModifiers : get = _get_modifiers
var BaseValue

signal reached_zero
signal increased
signal decreased

#Private values, do not modify outside of this!
var _value : int
var _is_dirty : bool
var _can_be_negative : bool = false
var _last_base_value = -2^63
var _stat_modifiers : Array[StatModifier] = []

func _init(base_value : int):
	BaseValue = base_value

func _get_modifiers() -> Array[StatModifier]:
	return _stat_modifiers
	

func _get_stat() -> int:
	if not _is_dirty and BaseValue == _last_base_value:
		return _value
	_last_base_value = BaseValue
	var last_value = _value
	_value = _calculate_final_value()
	_is_dirty = false
	if last_value > 0 and _value <= 0:
		reached_zero.emit()
		return _value
	if last_value < _value:
		increased.emit()
		return _value
	if last_value > _value:
		decreased.emit()
		return _value
	return _value
	
	

func add_modifier(mod : StatModifier) -> void:
	_is_dirty = true
	_stat_modifiers.append(mod)
	_stat_modifiers.sort_custom(_sort_modifiers_by_order)

func _sort_modifiers_by_order(a : StatModifier, b : StatModifier) -> bool:
	if a.Order > b.Order:
		return true
	return false
	
	
func remove_modifier(mod : StatModifier) -> bool:
	var modifier_index = _stat_modifiers.find(mod)
	if modifier_index == -1: 
		return false
	var modifier = _stat_modifiers[modifier_index]
	_stat_modifiers.remove_at(modifier_index)
	modifier.free()
	_is_dirty = true
	return true

func remove_all_modifiers() -> bool:
	var did_remove = false
	for mod in _stat_modifiers:
		did_remove = true
		_is_dirty = true
		mod.free()
	_stat_modifiers.clear()
	return did_remove

func remove_all_modifiers_from_source(obj : Object):
	var did_remove = false
	var to_remove = []
	for i in range(0, len(_stat_modifiers)):
		if _stat_modifiers[i].Source == obj:
			to_remove.append(i)
	for index in to_remove:
		did_remove = true
		_is_dirty = true
		var mod = _stat_modifiers[index]
		_stat_modifiers.remove_at(index)
		mod.free()
	return did_remove
	
	
func _calculate_final_value() -> int:
	var final_value = BaseValue
	var sum_percent_to_add = 0.0
	for i in range(0,len(_stat_modifiers)):
		var mod = _stat_modifiers[i]
		match mod.Type:
			400:#Override
				# Skip everything, return newest override
				return mod.Value
			100: #Percent Multiplier
				final_value += mod.Value
			200:
				#StatModType.PercentAdd:
				sum_percent_to_add += mod.Value
				#Add Percentages together for a total percentage change.
				#Check that this is the last PercentAdd modifier.
				#If it is, add the percentage to the final score.
				if i - 1 >= 0 or _stat_modifiers[i - 1].Type != 200:
					final_value *= 1 + sum_percent_to_add
					sum_percent_to_add = 0 
			300:
			#StatModType.Flat:
				final_value *= 1 + mod.Value
	if _can_be_negative:
		return floori(final_value)
	return clampi(floori(final_value), 0,1000000)
	
