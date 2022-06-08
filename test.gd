extends Path2D

var trans_points :PoolVector2Array = []
var points :PoolVector2Array = []
# 抛物线平面方向
var dirction = Vector2.RIGHT
# 平面旋转角度
var plane_rotate_rad :float= PI/3

var start_speed_vertical = 100
var speed_hotizontal = 20
var speed_vertical = start_speed_vertical

var gravity := -10.0

var timer := 0.0
var is_over := false

func _process(delta): 
	if is_over :return
	for i in range(8):
		caculate(dirction.rotated(PI/4 * i),delta)

# 计算位置
func caculate(direction,delta):
	timer += delta
	
	var vertical_heigt = start_speed_vertical*timer + (gravity * timer * timer )/2 
	var horizontal_position = direction * speed_hotizontal * timer 
	var trans_pos = trans(Vector3(horizontal_position.x,horizontal_position.y,vertical_heigt))
	
	trans_points.append(trans_pos)
	points.append(horizontal_position)
	
	update()
	
	if vertical_heigt  <= 0:
		is_over = true
		print("over")

# 绘制
func _draw():
	if points.size() < 2:return
	draw_polyline(points,Color.red,5.0)
	draw_polyline(trans_points,Color.chartreuse,5.0)


# 变换坐标
# x不变, y为投影
func trans(pos:Vector3):
	var x = pos.x
	var y = (pos.z - (pos.y*tan(plane_rotate_rad)))*sin(plane_rotate_rad) + (pos.y / cos(plane_rotate_rad))
	
	var t = Vector2(pos.y,pos.z).dot(Vector2(1,pow(3,0.5))) / 2 
	
	print(str(y) + " / " +str(t))
	return Vector2(x,y)
	
