extends Node
class_name BaseState


enum State {
	OFF,
	ON
}
var current_state = State.OFF
var state_node_index = 0
var state_manager



#Called by the parent State Machine at game startup as part of _ready()
func _initialize_state(state_manager, node_index) -> void:
	state_node_index = node_index
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		State.OFF:
			pass
		State.ON:
			_process_state(delta)
		
func _process_state(delta: float) -> void:
	print("In state")

func _change_state(new_state: int) -> void:
	current_state = new_state
	match current_state:
		State.OFF:
			exit()
		State.ON:
			enter()

func enter():
	print(str(name) + " state entered")

func exit():
	print(str(name) + " state exited")	
