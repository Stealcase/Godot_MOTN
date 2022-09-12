extends Node
class_name MonsterTexture

var id : String
var mon_name : String
var o_mon : MonsterImageHandler
var b_mon : MonsterImageHandler

var o_anim : SpriteFrames
var b_anim : SpriteFrames

func generate_animations():
	o_anim = SpriteFrames.new()
	b_anim = SpriteFrames.new()
	_extract_animation(o_mon, o_anim)
	_extract_animation(b_mon, b_anim)

func _extract_animation(mon :MonsterImageHandler, output : SpriteFrames):
	for k in mon.animations.keys():
		output.add_animation(mon.animations[k]["name"])
		output.set_animation_speed(mon.animations[k]["name"], 12)
		var start = mon.animations[k]["from"]
		var end = mon.animations[k]["to"]
		var i = start
		while i <= end:
			output.add_frame(mon.animations[k]["name"],mon.frames[i])
			i += 1
