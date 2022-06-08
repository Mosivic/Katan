extends StateTask


var brain:Node2D
var chase_speed := 80.0
var fixed_range := 5.0
var distance := 0.0

func _enter_task():
	brain = host.brain

func _physics_process_task(_delta):
	distance  = host.target_position.distance_to(host.global_position)
	
	if distance > fixed_range:
		host.animation_player.play("run")
		host.direction = (host.target_position - host.global_position).normalized()
		host.velocity = host.move_and_slide(chase_speed * host.direction)
		
		
	else:
		host.direction = Vector2.ZERO

