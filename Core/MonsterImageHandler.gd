extends Node

class_name MonsterImageHandler

var tex : ImageTexture
var data : Dictionary
var frames : Array[AtlasTexture]
var animations: Dictionary


func generate_frames():
#	frames = Array()
	for frame_meta in data["frames"]:
		var frame = frame_meta["frame"]
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(Vector2(frame["x"], frame["y"]),Vector2(frame["w"],frame["h"]))
		frames.append(atlas)
	for frame_tag in data["meta"]["frameTags"]:
		animations[frame_tag["name"]] = frame_tag
