extends RefCounted
class_name BattleSlot


var active_actors : Array[Actor]
var party_members : Array[Actor]
var party : Party
var is_active := false

func setup(act : Array[Actor], party_mem : Array[Actor]):
	active_actors = act
	party = act[0].party #Code smell
	party_members = party_mem
	is_active = true
