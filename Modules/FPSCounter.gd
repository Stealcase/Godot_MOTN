extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@export
var label_update_delay : float = 1

var current_step : float = 0 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_step += delta
	if current_step < label_update_delay:
		pass
	
	text = "fps: " + str(Engine.get_frames_per_second())
	current_step = 0
