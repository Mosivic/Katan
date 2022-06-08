extends Node2D

var points :PoolVector2Array= []

var points_origin :PoolVector2Array = []

var point_count = 40
var point_interval = 10

var L = point_count * point_interval
var l = point_interval

var minus_l = 100
var d := 0.1

func _ready():
	build_point()
	points_origin = points
	moni()

#func _process(delta):
#	pass

func moni():
	var c = (L - minus_l) / l
	var sum :float = 0.0
	var yu = 0.0
	while true:
		if abs(sum - c) <=  0.5:
			break
		else:
			sum = 0.0
			yu+= d
			
		for i in range(point_count):
			 sum +=  cos(yu*i)
	print(sum)
	print(c)
	print(yu)
	
	for i in range(point_count):
		var p :Vector2= points[i]
		p = p.rotated(yu*(point_count-1 - i))
		points[i] = p
	update()
	
	print(points_origin[-1])
	print(points[point_count-1])


func build_point():
	for i in range(point_count):
		points.append(Vector2(100+point_interval*i,100))
	update()
	
	
func _draw():
	for i in range(point_count-1):
		draw_line(points[i],points[i+1],Color.red,5.0)
	for i in range(point_count-1):
		draw_line(points_origin[i],points_origin[i+1],Color.red,5.0)
