extends AnimatedSprite2D
class_name BattlerProxyAnim


@export var extents: Rect2


func play_stagger():
	play("Hit")


func play_attack():
	play("Attack")


func play_death():
	play("Death")

func play_switch():
	play("Idle")

func play_idle():
	play("Idle")


func play_blink():
	play("Blink")
	
func play_appear():
	play("Idle")
