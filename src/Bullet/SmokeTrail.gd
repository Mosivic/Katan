extends Line2D

onready var tween = $Decay

var is_limited_lifetime := false

var gravity := Vector2.ZERO
var lifetime := [1.0,2.0]

var tick_speed :float= 0.05
var tick :float= 0.0

var wild_speed := 0.1
var wildness := 10.0

var points_age: = [0.0]
var min_spawn_point_distance := 10.0

func _ready():
	set_as_toplevel(true)
	clear_points()
	if is_limited_lifetime:
		stop()


func stop():
	tween.interpolate_property(self,"modulate:a",1.0,0.0,rand_range(lifetime[0],lifetime[1]),Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.start()

func _process(delta):
	if tick > tick_speed:
		tick = 0
		
		for p in range(get_point_count()):
			var rand_vector := Vector2(
				rand_range(-wild_speed,wild_speed),
				rand_range(-wild_speed,wild_speed)
			)
			points_age[p] += 5 *delta
			points[p] +=  gravity + (rand_vector * wildness * points_age[p])
			
	else:
		tick += delta

func add_point(point_pos:Vector2,at_pos:=-1):
	if get_point_count() > 0 and min_spawn_point_distance >  point_pos.distance_to(points[get_point_count()-1]):
		return
	points_age.append(0.0)
	.add_point(point_pos,at_pos)

func _on_Decay_tween_all_completed():
	get_parent().is_dead = true

