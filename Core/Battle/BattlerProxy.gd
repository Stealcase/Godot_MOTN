extends Node2D
class_name BattlerProxy

@export var TURN_START_MOVE_DISTANCE: float = 40.0
@export var TWEEN_DURATION: float = 0.3

var tween : Tween
var battler_anim : BattlerProxyAnim
var position_start: Vector2 = Vector2(0,0)
var backwards : Vector2 = Vector2(0,0)
var forwards : Vector2 = Vector2(0,0)

var blink: bool = false
var is_left : bool = false

var actor : Actor

func _ready():
	tween = create_tween()
	await appear()

func set_pos(pos: Vector2, left: bool = false):
	is_left = left
	position_start = pos
	backwards = Vector2(-1.0 * TURN_START_MOVE_DISTANCE, 0.0) if is_left else Vector2(1.0 * TURN_START_MOVE_DISTANCE, 0.0)
	forwards = Vector2(1.0 * TURN_START_MOVE_DISTANCE, 0.0) if is_left else Vector2(-1.0 * TURN_START_MOVE_DISTANCE, 0.0)
	position = pos + backwards
	
func initialize(p_actor : Actor):
	#This is called before "Ready" by our parent
	for child in get_children():
		if child is BattlerProxyAnim:
			battler_anim = child
			battler_anim.frames = p_actor.b_animator.frames
			break
	hide()
	self.actor = p_actor
	self.actor.party.actor_switched.connect(switch_actor)


func switch_actor(old_actor : Actor, _new_actor):
	await move_backwards()
	hide()
	await appear()


func move_forward():
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property(self,
			"position", 
			self.position_start + TURN_START_MOVE_DISTANCE * forwards,
			TWEEN_DURATION).finished
	return true
	
	
func move_backwards():
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property(self,
			"position", 
			self.position_start + TURN_START_MOVE_DISTANCE * backwards,
			TWEEN_DURATION).finished
	return true

func move_to(target: BattlerProxy):
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(
		self,
		'global_position',
		target.global_position,
		TWEEN_DURATION).finished
	return true


func return_to_start():
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	if tween.is_running():
		tween.stop()
	await tween.tween_property(
		self, 'position',
		position_start, 
		TWEEN_DURATION).finished
	return true


func set_blink(value):
	blink = value
	if blink:
		battler_anim.play_blink()
	else:
		battler_anim.play_idle()
	await battler_anim.animation_finished


func play_stagger():
	battler_anim.play_stagger()
	await battler_anim.animation_finished


func play_death():
	battler_anim.play_death()
	await battler_anim.animation_finished


func appear():
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	if is_left:
		battler_anim.flip_h = true
	show()
	battler_anim.play_appear()
	if tween.is_running():
		tween.stop()
	await tween.tween_property(self,
			"position", 
			self.position_start,
			TWEEN_DURATION * 2).finished
	return true

