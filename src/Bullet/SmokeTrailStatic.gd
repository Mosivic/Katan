extends Line2D


var is_limited_lifetime := false

var gravity := Vector2(0,-4)
var wind := Vector2(3,2)

var lifetime := [1.0,2.0]

var tick_speed :float= 0.05
var tick :float= 0.0

var wild_speed := 0.05
var wildness := 3.0

var swag_strength := 0.0
var turbulance := 3.0
var tile_move_time := 0.0

var points_age: = [0.0]
var min_spawn_point_distance := 2.0
var max_point_count := 100

var noise :OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	noise.octaves = 2
	set_as_toplevel(true)
	clear_points()



func _process(delta):
	tile_move_time = wrapf(tile_move_time+delta*100,0,2000)
	

	if tick > tick_speed:
		tick = 0
		
		for p in range(get_point_count()):
			points_age[p] += 5 *delta
			var rand_vector := Vector2(
				rand_range(-wild_speed,wild_speed),
				rand_range(-wild_speed,wild_speed)
			)
			var noise_x = points[p].x + tile_move_time * turbulance
			var noise_y = points[p].y + tile_move_time * turbulance
			swag_strength = lerp(swag_strength,noise.get_noise_2d(noise_x,noise_y)*points_age[p]*0.5,0.2)
			

			points[p] +=  gravity + (rand_vector * wildness * points_age[p]) + (wind*swag_strength)
			
			
	else:
		tick += delta

func add_point(point_pos:Vector2,at_pos:=-1):
#	if get_point_count() > 0 and min_spawn_point_distance >  point_pos.distance_to(points[get_point_count()-1]):
#		return
		
	if get_point_count() > max_point_count:
		remove_point(0)
		points_age.pop_front()
	.add_point(point_pos,at_pos)
	points_age.append(0.0)
	



