extends Node
class_name Brain

enum ControllerSource{
	AI,
	Player,
}

var party : Party
var brain_type : ControllerSource

var direction_input : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var _is_move_input: bool = false


func setup_target(p_party : Party):
	party = p_party
	pass
	#Override this in inheriting classes
