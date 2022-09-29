extends Node

class_name Calculator

var defaultEffectivePercentage : float = 0.5 
var defaultResistPercentage : float = 0.5 

static func calculate_damage(value : int, damage_multiplier : float) -> int:
	var fValue : float = float(value)
	fValue *= damage_multiplier
	var calculatedValue : int = roundi(fValue)
	print("Calculated Damage is " + str(fValue) + " and Rounded it is " + str(calculatedValue))
	return calculatedValue


#Calculates what the new damage value is with percentage calculation
static func calculate_damage_multiplier(attackType : ElementalType, target : Array[ElementalType]) -> float: 
	var defaultEffectivePercentage : float = 0.5 
	var defaultResistPercentage : float = 0.5
	return calculate_damage_multiplier_override(attackType, target, defaultEffectivePercentage, defaultResistPercentage)


static func calculate_damage_multiplier_override(attackType : ElementalType, target : Array[ElementalType], _effectivePercentage : float, _resistPercentage : float) -> float:
	var damageMultiplier : float = 1
	var immune : bool = false
	for type in target:
		print($"Type {target[i].name} versus {attackType.name}");
		#Check the interaction between the Casting Attack Type, and the Elemental Types of the recipient.
		#TODO: Check which axis these interact on; maybe it's flipped.
		if type.weakness.any(func(s): return s == attackType.id):
			damageMultiplier += _effectivePercentage
			print($"Increased Effectiveness")
		if type.resistance.any(func(s): return s == attackType.id):
			damageMultiplier -= _resistPercentage
			print($"Reduced Effectiveness")
		if type.immune.any(func(s): return s == attackType.id):
			immune = true 
			print($"Immune")
	if immune:
		return 0.0
	return damageMultiplier;
