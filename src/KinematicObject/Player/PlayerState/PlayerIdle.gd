extends StateTask


func _physics_process_task(delta):
	host.animation_player.play("idle")
	emit_signal("select","Run")
