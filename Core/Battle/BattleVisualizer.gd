extends Node2D

class_name BattleVisualizer

var proxy_prefab = preload("res://Core/Battle/BattlerProxy.tscn")

var proxies : Node2D
var left_pos : Node2D
var right_pos : Node2D

var viewer_party : Party
var base_battle : Battle


func setup_visuals(party : Party, battle : Battle):
	base_battle = battle
	viewer_party = party
	base_battle.actor_acting.connect(_on_actor_acting)
	base_battle.subscribe_to_visuals(self)
	proxies = get_node("Proxies")
	left_pos = get_node("Positions/Left_Pos")
	right_pos = get_node("Positions/Right_Pos")
	for actor in battle.active_actors:
		var instance : BattlerProxy = proxy_prefab.instantiate()
		if actor.party == party:
			instance.set_pos(left_pos.position, true)
			instance.initialize(actor)
		else:
			instance.set_pos(right_pos.position, false)
			instance.initialize(actor)
		proxies.add_child(instance)

func _on_actor_acting(actor, target):
	var children = proxies.get_children()
	var self_actor : BattlerProxy
	var target_actor : BattlerProxy
	for child in children:
		if child.actor == actor:
			self_actor = child
		elif child.actor == target:
			target_actor = child
	if self_actor and target_actor:
		await self_actor.move_to(target_actor)
		var res = await self_actor.return_to_start()
		base_battle.mark_visual_done(self)
