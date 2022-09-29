extends Node2D
class_name Actor

signal InteractedWith #UnityEvent 
signal statsChanged #StatsEvent 
signal ExpChanged #DoubleIntEvent 
signal Death #ActorEvent 
signal AttackPerformed #Action 
signal Emote #IntegerEvent 
signal MotionStop #Action 
signal Particle #IntegerEvent 
signal FacingChanged #Action<Directions> 
signal MoveChosen #Action<ActionObject> 
signal health_restored(old_val, new_val) #Action<Elemental> 
signal damage_taken(old_val, new_val) #Action<Elemental> 
signal PartyJoin #Action<PlayerBus> 
signal leave_party_decision #Action<Actor> 
signal speak #DialogueEvent 
signal state_changed(old_state, new_state)

var breed : Breed
var actorName : String
var actions : Array[Action]
var party : Party
var is_in_party = false


enum ActorState{
		Inactive = 0,
		Active = 1,
		NeedSwitch = 2,
		Dead = 3
	}
var current_state : ActorState = ActorState.Inactive

func set_state(state : ActorState) -> void:
	if current_state != state:
		var old_state = current_state
		current_state = state
		state_changed.emit(old_state, old_state)

@onready var n_stats : StatsNode = $Stats
@onready var o_animator : AnimationController = $O_Animator
@onready var b_animator : AnimationController = $B_Animator

func _ready():
	n_stats.died.connect(_on_death)
	n_stats.damage_taken.connect(_on_damage_taken)
	n_stats..connect(_on_damage_taken)
	
func _on_death():
	set_state(ActorState.Dead)

func _on_damage_taken(old_val, new_val):
	damage_taken.emit(old_val, new_val)


func _on_health_restored(old_val, new_val):
	health_restored.emit(old_val, new_val)


#Call from Party
func join_party(new_party :Party):
	if is_in_party:
		party.remove(self)
	party = new_party
	is_in_party = true

#func take_damage():
	
	
func perform_action(action :Action, target):
	if target is StatsNode:
		target.take_damage(action)

	var children = target.get_children()
	for child in children:
		if child is StatsNode:
			child.take_damage(target)

