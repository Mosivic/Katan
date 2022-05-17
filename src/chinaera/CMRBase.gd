class_name CMRBase
extends Path2D


const TYPE = {
	NULL = 0,
	SHIELD = 1,
	HAND = 2,
}

var type = TYPE.NULL
# 原始点
var origin_points : = []
# 变换点,由原始点变换而来
var trans_points : = []
# 单位表 key为point index,value为单位实例引用
var single_map := {}

var point_interval := 5.0
var insert_index :int= 0
var points_size :int= 0

var is_need_sort := false

func _ready():
	init_points()
	get_parent().resgister_compoent(self)

func _process(delta):
	check_and_sort()
	sync_behavior()

func init_points():
	origin_points = curve.get_baked_points()
	points_size = origin_points.size()
	
	for i in range(points_size):
		var pos := to_global(origin_points[i])
		trans_points.append(pos)
	
	if trans_points.size() <= 1:
		point_interval = curve.bake_interval
		print("curve point size less one")
		return
	point_interval = trans_points[0].distance_to(trans_points[1])


func check_and_sort():
	if is_need_sort:
		sort_singles()
		is_need_sort = false
	

# 对单体的行为进行状态同步, 移除已释放的单体,进行重新排序
func sync_behavior():
	for i in single_map.keys():
		var single:Node2D= single_map[i]
		if  not is_instance_valid(single): # single is freed
			is_need_sort = true
			single_map.erase(i)
			continue
		single.set_target_position(global_position + trans_points[i])



func assemble_single(caught:Node2D)->bool:
	var radius = caught.get_collision_radius()
	var result = check_insert(radius)
	if result[0] == false:
		return false
	else:
		var index :int= result[1]
		single_map[index] = caught
		caught.set_state_caught(get_parent().brain)
		return true

# 检测插入已满,不准插入
# 检测插入位置为起始点, 允许插入
# 检测其他插入位置
func check_insert(radius:float)->Array:
	if insert_index >= points_size - 1:
		return [false,0] 
	if insert_index == 0:
		var add = ceil(radius/point_interval)
		insert_index += add
		return [true,0]
	else:
		var add = ceil(radius/point_interval)
		if insert_index + add >= points_size:
			return [false,0]
		insert_index = insert_index + 2*add
		return [true,insert_index-add]

# 对现有single位置进行重新排序
func sort_singles():
	insert_index = 0
	var new_single_map := {}
	for single in single_map.values():
		var radius = single.get_collision_radius()
		var result = check_insert(radius)
		if result[0] == false:  # insert failed
			continue
		else:			#insert succeed
			var index = result[1]
			new_single_map[index] = single
			single.set_state_caught(get_parent().brain)
	single_map = new_single_map
