extends Node

class_name Party

@onready var battle_visualizer = load("res://Core/Battle/BattleVisualizer.tscn")
# Called when the node enters the scene tree for the first time.

#enum PartyState{
#	Overworld,
#	Talking,
#	Battle
#}


#CRUD ----------------------------
signal actor_added(p_actor : Actor)
signal actor_removed(p_actor : Actor)
signal actor_switched(old_actor : Actor, new_actor : Actor)

signal actor_speak

#signal state_change(state : PartyState)
signal action_chosen(actor : Actor, action : Action, target : Actor)

signal need_switch(p_actor : Actor) # When an actor needs to be switched out
signal need_battle_action(p_actor : Actor, battle_slots : Array[BattleSlot])
#STATE -----------------------------------------
var brain : Brain
#var state : PartyState = PartyState.Overworld
var active_actor : Actor

var visualize_battle : bool = false
var actor_count : int = 0

@export var max_actors : int = 4


func add(p_actor : Actor) -> void:
	print("adding " + str(p_actor.name) + "to party" + str(name))
	p_actor.add_to_group(self.name)
	p_actor.join_party(self)
	actor_added.emit(p_actor)
	if actor_count == 0:
		actor_switch(p_actor)
	actor_count+=1
	pass


func remove(p_actor : Actor) -> void:
	p_actor.remove_from_group(self.name)
	actor_removed.emit(p_actor)
	actor_count -= 1
	if actor_count < 1:
		if brain.brain_type == 0:
			queue_free()
	pass


func get_actors() -> Array[Actor]:
	var party_members = get_tree().get_nodes_in_group(self.name)
	var typed_party : Array[Actor] = []
	for member in party_members:
		typed_party.append(member as Actor)
	return typed_party


func get_living_inactive_actors() -> Array[Actor]:
	var party_members = get_tree().get_nodes_in_group(self.name)
	var typed_party : Array[Actor] = []
	for member in party_members:
		if member.current_state == 0:
			typed_party.append(member as Actor)
	return typed_party


func actor_switch(p_actor : Actor) -> void:
	if p_actor != active_actor:
		var old_actor = active_actor
		active_actor = p_actor
		active_actor.set_state(1)
		actor_switched.emit(old_actor, active_actor)


func actor_need_switch(p_actor : Actor) -> void:
	need_switch.emit(p_actor)

func initialize_battle_visualizer(battle : Battle) -> void:
	#Start an instance of the battle visualizer
	var visualizer_instance = battle_visualizer.instantiate()
	visualizer_instance.setup_visuals(self, battle)
	var viewport = get_parent().get_parent().viewport
	viewport.add_child(visualizer_instance)

func actor_need_battle_action(p_actor : Actor, battle_slots : Array[BattleSlot]) -> void:
	need_battle_action.emit(p_actor, battle_slots)

func battle_action_chosen(p_actor : Actor, p_action : Action, p_target : Actor):
	action_chosen.emit(p_actor, p_action, p_target)
