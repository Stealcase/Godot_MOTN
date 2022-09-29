extends Object

class_name StatModifier

enum StatModType{
	PercentMult = 100,
	PercentAdd = 200,
	Flat = 300,
	Override = 400
	}

var Value : int
var Type : StatModType
var Order : int
var Source

func _init(value : int, type : StatModType, order : int, source : Object):
	Value = value
	Type = type
	Order = order
	Source = source


static func new_source(value : int, source : Object, type : StatModType = StatModType.Flat) -> StatModifier: 
	return StatModifier.new(value, type, type, source)

static func new_modifier_type(value : int,  type : StatModType = StatModType.Flat) -> StatModifier: 
	return StatModifier.new(value, type, type, null)

static func new_order_override(value : int, type : StatModType, order : int) -> StatModifier: 
	return StatModifier.new(value, type, order, null)

static func new_modifier_source(value : int, type : StatModType, source : Object) -> StatModifier: 
	return StatModifier.new(value, type, type, source)
