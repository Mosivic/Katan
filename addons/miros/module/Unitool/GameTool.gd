extends Node2D
class_name GameTool


## 笛卡尔坐标转等距坐标
func cartesian_to_isometric(pos:Vector2)->Vector2:
	var Global = load("res://addons/miros/core/Miros.gd").GetGlobal()
	var x = pos.x/Global.tile_width + pos.y/Global.tile_heigh
	var y = -pos.x/Global.tile_width + pos.y/Global.tile_heigh
	return Vector2(floor(x),floor(y))

## 等距坐标转笛卡尔坐标
func isometric_to_cartesian(pos:Vector2):
	var Global = load("res://addons/miros/core/Miros.gd").GetGlobal()
	var x = Global.tile_width/2*pos.x - Global.tile_width/2*pos.y
	var y = Global.tile_heigh/2*pos.x + Global.tile_heigh/2*pos.y
	return Vector2(x,y)

## 单位坐标转笛卡尔坐标
func unit_to_cartesian(pos:Vector3):
	var Global = load("res://addons/miros/core/Miros.gd").GetGlobal()
	var pos_iso = Vector2(pos.x,pos.y)
	var heigh = pos.z
	var pos_car = isometric_to_cartesian(pos_iso)-Vector2(0,Global.tile_layer_heigh*heigh)
	return pos_car

## 获取当前鼠标位置等距坐标
func get_mouse_pos_isometric_pos()->Vector2:
	return  cartesian_to_isometric(get_global_mouse_position())

## 获取等距坐标间距离
func get_distance_by_pos_iso(p1:Vector2,p2:Vector2)->float:
	var Global = load("res://addons/miros/core/Miros.gd").GetGlobal()
	var x1 = Global.currTileMapData[p1][0].x
	var y1 = Global.currTileMapData[p1][0].y
	var x2 = Global.currTileMapData[p2][0].x
	var y2 = Global.currTileMapData[p2][0].y
	return sqrt(pow(abs(x1)-abs(x2),2) + pow(abs(y1)-abs(y2),2))

## 获取笛卡尔坐标间距离
func get_distance_by_pos_car(p1:Vector2,p2:Vector2)->float:
	var x1 = p1.x
	var y1 = p1.y
	var x2 = p2.x
	var y2 = p2.y
	return sqrt(pow(abs(x1)-abs(x2),2) + pow(abs(y1)-abs(y2),2))
