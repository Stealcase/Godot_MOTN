extends Brain

class_name AIBrain

func _init():
	brain_type = ControllerSource.AI #AIBrain


func setup_target(p_party : Party):
#	super(setup_target(p_party)) #Call base class
	party = p_party
	party.need_switch.connect(_on_need_to_switch)
	party.need_battle_action.connect(_on_need_battle_action)
	pass


func _on_need_to_switch(actor : Actor):
	var actors = party.get_living_inactive_actors()
	if 0 < len(actors):
		party.actor_switch(actors[0])


func _on_need_battle_action(actor : Actor, slots : Array[BattleSlot]):
	var self_slot = slots.filter(find_self)
	var other_slots = slots.filter(find_others)
	party.battle_action_chosen(actor, actor.actions[0], other_slots[0].active_actors[0])

func find_self(array_elem : BattleSlot) -> bool:
	if array_elem.party == party:
		return true
	return false

func find_others(array_elem : BattleSlot) -> bool:
	if array_elem.party == party:
		return false
	return true
