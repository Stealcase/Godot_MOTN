extends Node
class_name Battle



enum TurnState{
	NoneState = 0,
	BeginBattleState = 1,
	SummonActorsState = 2,
	SpeedCheckState = 3,
	WaitForInputState = 4,
	ActionState = 5,
	CheckStatusState = 6,
	EndBattleState = 10
}
# Number of entities that are viewing the battle, which we have to wait for before continuing the battle logic 
var viewers : int = 0

var default_time_scale : float = 1.0

var time_scale : float = 1.0

var battle_state : TurnState

func enter_battle(actor_1 : Actor, actor_2 : Actor):
	battle_state = TurnState.BeginBattleState
	active_actors = [actor_1, actor_2]
	var party_members_1 = actor_1.party.get_actors()
	var party_members_2 = actor_2.party.get_actors()
	var battle_slot_1 = BattleSlot.new()
	var battle_slot_2 = BattleSlot.new()
	battle_slot_1.setup([actor_1], party_members_1)
	battle_slot_2.setup([actor_2], party_members_2)
	battle_slots.append(battle_slot_1)
	battle_slots.append(battle_slot_2)
	subscribe_party(actor_1.party)
	subscribe_party(actor_2.party)
	print(str(self.name) + " Entered Battle")
	summon_actors()
	
func summon_actors():
	battle_state = TurnState.SummonActorsState
	var actions_needed = foreach_active_actor(check_death_state)
	if actions_needed > 0:
		pass #TODO: Wait for all actions to be completed before continue
	print(str(self.name) + " Summoned Actors")
	speed_check()


func check_death_state(p_actor : Actor) -> bool:
	print(str(self.name) + " Checking death status")
	match(p_actor.current_state):
		0:
			return false
		1:
			return false
		2:
			p_actor.party.actor_need_switch(p_actor)
			return true
		3: 
			p_actor.party.actor_need_switch(p_actor)
			return true
	return false


func foreach_active_actor(do_thing : Callable) -> int:
	var things_done = 0
	for slot in battle_slots:
		for actor in slot["active_actors"]:
			if do_thing.call(actor):
				things_done += 1
	return things_done
	
	
var battle_slots : Array[BattleSlot]

var history : Array
var queued_actions : Array
var active_actors : Array
var actor_needs_action : Array # Actors who have recently been deceased or needs some sort of action

	
func process_turn():
	pass
	for action in queued_actions:
		action.perform()

func Action():
	while len(queued_actions) > 0:
		pass
		#Yield
		#PerformActions
	
func wait_for_input():
	print(str(self.name) + " Waiting for input")
	battle_state = TurnState.WaitForInputState
	foreach_active_actor(_emit_action_required)
	pass
	
var actions_required : int = 0
var inputs : Dictionary

func _on_receive_input(actor : Actor, action : Action, target_actor : Actor):
	print("Received Input!!!!")
	if battle_state == TurnState.WaitForInputState:
		inputs[actor] = {
			"actor" = actor,
			"action" = action,
			"target" = target_actor
		}
		for active_actor in active_actors:
			if active_actor in inputs:
				continue
			print("Waiting for all input")
			return
		perform_actions()


func perform_actions():
	battle_state = TurnState.ActionState
	print(str(self.name) + "Action State")
	for actor in active_actors:
		var action_obj = inputs[actor]
		if reset_visualizers(): #Check if there are any visualizers we need to wait for
			await actor_perform(actor, action_obj["target"])
		action_obj["target"].n_stats.take_damage(action_obj["action"].value, 0, action_obj["action"].type, action_obj["action"].characteristic)
	check_status()
# Sends a signal to a party that input is required. 
func actor_perform(actor: Actor, target : Actor):
	actor_acting.emit(actor, target)
	await visuals_done
	return true

signal actor_acting(actor, target)

func _emit_action_required(p_actor : Actor):
	print("Emitting Action Required")
	p_actor.party.actor_need_battle_action(p_actor, battle_slots)
	


func speed_check():
	battle_state = TurnState.SpeedCheckState
	print(str(self.name) + " SpeedCheckState")
	#CalculateSpeedOrder
	active_actors.sort_custom(_custom_sort_actors_by_speed)
	wait_for_input()

var switches_needed : int = 0

func check_status():
	battle_state = TurnState.CheckStatusState
	switches_needed = foreach_active_actor(check_death_state)
	if switches_needed:
		return
	else: 
		speed_check()

	
func _custom_sort_actors_by_speed(a : Actor, b : Actor):
	return a.n_stats.stats.speed > b.n_stats.stats.speed
	
	
func BeginBattle():
	pass
	#Summon Actors
	#Assign Targets
	#Update Hud

func CheckStatus():
	pass
	#ApplyStatusConditions
	#Handle Deadth
	#EndBattle OR WaitForInput

enum PlayerState{
	NeedSwitch,
	Dead
}

func handle_death():
	print(str(self.name) + " Handling Death Queue")
	if len(actor_needs_action) > 0:
		var player = actor_needs_action.pop_back()
		print($"Dequeued {player}, {PlayerNeedsAction.Count} in queue remaining")
		match(player.playerStates.state):
			PlayerState.NeedSwitch:
				print($"{player.playerStates.color} wanted to switch! REMOVING ACTOR", player)
#				RemoveActiveActor(player.RemoveDeadActor())
#				ActorDefeated(50)
				player.ReplaceActiveActor()
			PlayerState.Dead:
				print($"{player.playerStates.color} Player is Dead!", player)
#				RemoveActiveActor(player.RemoveDeadActor())
#				ActorDefeated(50)
#				RemovePlayer(player)
			_:
				print($"{player.playerStates.color} Player was added to this queue despite being Active", player);

func unsubscribe_party(party : Party):
	party.actor_switched.disconnect(_on_actor_switched)
	
#	party.disconnect("move_chosen",self,"_on_receive_actions")
#	party.disconnect("actor_speak",self,"_on_speak")

func subscribe_party(party : Party):
	party.actor_switched.connect(_on_actor_switched)
	party.action_chosen.connect(_on_receive_input)
	if party.visualize_battle:
		party.initialize_battle_visualizer(self)
		pass
#	party.connect("actor_switched",self,"_on_add_actor_to_active")
#	party.connect("move_chosen",self,"_on_receive_actions")
#	party.connect("actor_speak",self,"_on_speak")

func _on_actor_switched(old_actor : Actor, new_actor : Actor) -> void:
	replace_actor(old_actor, new_actor)
	switches_needed -= 1
	if switches_needed == 0:
		speed_check()


func replace_actor(old_actor : Actor, new_actor) -> void:
	var search = func(array_elem, act : Actor) -> bool:
		if array_elem["party"] == act.party:
			return true
		return false
	var index = battle_slots.bsearch_custom(old_actor, search)
	battle_slots[index]["active_actors"].erase(old_actor)
	battle_slots[index]["active_actors"].append(new_actor)
	active_actors.erase(old_actor)
	active_actors.append(new_actor)
	pass

#A dictionary of visualizers. Anytime 

var subscribed_visualizers : Dictionary = {}

func reset_visualizers() -> bool:
	if len(subscribed_visualizers) > 0:
		for displays in subscribed_visualizers.keys():
			subscribed_visualizers[displays] = true
		return true
	return false


func subscribe_to_visuals(visualizer):
	subscribed_visualizers[visualizer] = false


func unsubscribe_to_visuals(visualizer):
	subscribed_visualizers.erase(visualizer)


func mark_visual_done(visualizer):
	subscribed_visualizers[visualizer] = true
	for displays in subscribed_visualizers.keys():
		if subscribed_visualizers[displays] == false:
			return
	visuals_done.emit()


signal visuals_done

