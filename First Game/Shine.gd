extends Area2D

signal enemy_hit # hit an enemy. boosts points by 5


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$ShineHitbox.disabled = true # Replace with function body.

func attack(): #Code for the shine attacking
	$ShineHitbox.disabled = false
	$ShineSound.play()
	show()
	$AnimateTimer.start()
	yield($AnimateTimer,"timeout")
	$ShineHitbox.disabled = true
	hide()


#func _process(delta):
#	pass

func _on_Shine_body_entered(body):
	if body.is_in_group("mobs"):
		emit_signal("enemy_hit")
		print("i hit em bozo")
		body.queue_free()
