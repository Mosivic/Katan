extends StateTask


var brain:Node2D
var chase_speed := 80.0


var fixed_range := 5.0

func _enter_task():
	brain = host.brain

func _physics_process_task(_delta):
	host.animation_player.play("run")
	var direction:Vector2= (host.target_position - host.global_position).normalized()
	var distance :float = host.target_position.distance_to(host.global_position)
	
	if distance > fixed_range:
		host.move_and_slide(chase_speed * direction)


