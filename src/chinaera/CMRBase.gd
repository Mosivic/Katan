class_name CMRBase
extends Path2D


const TYPE = {
	NULL = 0,
	SHIELD = 1
}

var type = TYPE.NULL


var real_points : = []
var dirty_points := []



func _init():
	caculate_points()

func caculate_points():
	var points = curve.get_baked_points()
	for p in points:
		var pos = Vector2(p.x*scale.x , p.y*scale.y)
		real_points.append(pos)

	for i in range(points.size()):
		var pos :Vector2= real_points[i]
		var len_left = INF
		var len_right = INF
		
		if i == 0:
			len_right = pos.distance_to(real_points[i+1])
		elif i == points.size() - 1:
			len_left = pos.distance_to(real_points[i-1])
		else:
			len_left = pos.distance_to(real_points[i-1])
			len_right = pos.distance_to(real_points[i+1])
		
		dirty_points.append({
			"pos": pos,
			"len_left":len_left,
			"len_right":len_right,
			"ref": null,
		})
			


func assemble_single(catched:Node2D)->bool:
	# Catch
	for i in range(dirty_points.size()):
		var result = check_insert(i,catched.uim.size)
		if result:
			dirty_points[i]["ref"] = catched
			catched.global_position =  dirty_points[i]["pos"]
			catched.uim.is_catched = true
			
			print("Catched with name:" + catched.name)
			return true
		else:
			continue
	# Not catched
	return false

func check_insert(i,size)->bool:
	if dirty_points[i]["ref"] != null:
		return false
	var len_left
	var len_right
	var lsize = size 
	var rsize = size
	var li = i
	var ri = i
	# left check
	while true:
		if dirty_points[li]["ref"] != null:
			return false
		len_left = dirty_points[li]["len_left"]
		lsize -= len_left
		if lsize < 0:
			break
		else:
			li -= 1
	# right check
	while true:
		if dirty_points[ri]["ref"] != null:
			return false
		len_right = dirty_points[ri]["len_left"]
		rsize -= len_right
		if lsize < 0:
			break
		else:
			ri += 1
	return true
