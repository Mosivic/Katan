extends StateTask


var brain:Node2D

func _enter_task():
	brain = host.brain

func _physics_process_task(_delta):
	host.animation_player.play("run")
	var target_pos = brain.global_position
	host.global_position = host.global_position.move_toward(brain.global_position,_delta*100)
	pass
