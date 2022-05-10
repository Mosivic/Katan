extends Node2D
class_name Tilemap

export(Resource) var tilemap_res
var tiles:Dictionary
var data:Dictionary

var occlusion_tiles:Array

func _ready():
	var Global = load("res://addons/miros/core/Miros.gd").GetGlobal()
	data = tilemap_res.data
	Global.currTileMap = self
	Global.currTileMapData = tilemap_res.data
	Global.currTileMapRes = tilemap_res
#	for tile in get_children():
#		var temp:Array = tile.name.split("_")
#		var key = Vector2(int(temp[1]),int(temp[2]))
#		tiles[key] = tile
#
#
## 地形tile上升
#func rise_tile(pos:Vector2,heigh:int):
#	var tile = tiles[pos]
#	var tween =get_node("../Tween")
#	data[pos][1] += heigh
#	data[pos][0] = tile.position-Vector2(0,heigh*16)
#	tween.interpolate_property(tile,"position",tile.position,
#			tile.position-Vector2(0,heigh*16),4.0,Tween.TRANS_LINEAR, 
#			Tween.EASE_IN_OUT)
#	tween.start()

	
## 判断tilemap中是否有给定位置tile,pos_unit
func is_has_tile_in_tilemap_res_by_pos_unit(pos:Vector3)->bool:
	return data.has(pos)
	
## 判断tilemap中是否有给定位置tile,pos_iso
func is_has_tile_in_tilemap_res_by_pos_iso(pos:Vector2)->bool:
	for key in data:
		if Vector2(key.x,key.y) == pos:
			return true
	return false
	
## 获取tilemap中给定位置的tile_unit,pos_iso
func get_tile_pos_unit_by_pos_iso(pos:Vector2):
	for key in data:
		if Vector2(key.x,key.y) == pos:
			return key

## 获取指定road的总费用
func get_road_cost(road:Array)->int:
	var num = road.size()
	var cost:int = 0
	if num >= 2:
		for i in range(num-2):
			cost += road[i+1][2]
		return cost
	return cost
	
## 通过等距坐标获取Tile的实际笛卡尔坐标
func get_tile_position_by_pos_unit(pos:Vector3)->Vector2:
	return data[pos]
	

# 遮挡剔除
#func occlusion_culling():
#	for tile in occlusion_tiles:
#		tile.modulate.a = 1.0
#	occlusion_tiles.clear()
#	var pos_ios = editor.get_mouse_pos_isometric_pos()
#	var is_has_tile = editor.is_has_tile_in_tilemap_tilemap_res(pos_ios)
#	if is_has_tile:
#		#var p1 = pos_ios+Vector2(1,0)
#		#var p2 = pos_ios+Vector2(0,1)
#		var p3 = pos_ios+Vector2(1,1)
##		if editor.is_has_tile_in_tilemap_tilemap_res(p1):
##			occlusion_tiles.append(get_node(editor.get_tile_path_from_scene(p1)))
##		if editor.is_has_tile_in_tilemap_tilemap_res(p2):
##			occlusion_tiles.append(get_node(editor.get_tile_path_from_scene(p2)))
#		if editor.is_has_tile_in_tilemap_tilemap_res(p3):
#			occlusion_tiles.append(get_node(editor.get_tile_path_from_scene(p3)))
#	for tile in occlusion_tiles:
#		tile.modulate.a = 0.3
