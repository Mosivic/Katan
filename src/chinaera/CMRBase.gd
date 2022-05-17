class_name CMRBase
extends Path2D


const TYPE = {
	NULL = 0,
	SHIELD = 1,
	HAND = 2,
}

var type = TYPE.NULL

var origin_points : = []
var trans_points : = []
# 点消息, index为point index,value为点相关消息
var points_info := []
# 单位表 key为point index,value为单位实例引用
var single_map := {}

func _ready():
	init_points()
	get_parent().resgister_compoent(self)

#func _process(delta):
#	for i in single_map.keys():
#		var single:Node2D= single_map[i]
#		single.global_position = global_position + trans_points[i]

func init_points():
	var points = curve.get_baked_points()
	for p in points:
		var pos := Vector2(p.x*scale.x,p.y*scale.y)
#		pos += position
#		pos = pos.rotated(rotation_degrees)
		origin_points.append(pos)
	for i in range(points.size()):
		var pos :Vector2= origin_points[i]
		var len_left = INF
		var len_right = INF
		
		if i == 0:
			len_right = pos.distance_to(origin_points[i+1])
		elif i == points.size() - 1:
			len_left = pos.distance_to(origin_points[i-1])
		else:
			len_left = pos.distance_to(origin_points[i-1])
			len_right = pos.distance_to(origin_points[i+1])
		
		points_info.append({
			"pos": pos,
			"len_left":len_left,
			"len_right":len_right
		})
	trans_points = origin_points.duplicate(true)


func update_single_position(ref:Node2D,pos:Vector2):
	ref.global_position = pos


func assemble_single(caught:Node2D)->bool:
	# Assemble Succeed
	for i in range(origin_points.size()-1):
		var result = check_insert(i,caught.size)
		if result:
			single_map[i] = caught
			caught.set_caught(get_parent().brain)
			
			return true
		else:
			continue
	# Assemble Failed
	return false

func check_insert(i,size)->bool:
	if single_map.has(i):
		return false
	var len_left
	var len_right
	var lsize = size 
	var rsize = size
	var li = i
	var ri = i
	# left check
	while true:
		if single_map.has(li):
			return false
		len_left = points_info[li]["len_left"]
		lsize -= len_left
		if lsize < 0:
			break
		else:
			li -= 1
	# right check
	while true:
		if single_map.has(ri):
			return false
		len_right = points_info[ri]["len_right"]
		rsize -= len_right
		if rsize < 0:
			break
		else:
			ri += 1
	return true
