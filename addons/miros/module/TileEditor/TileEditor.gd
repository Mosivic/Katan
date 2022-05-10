tool
extends Node2D

export(NodePath) var tilemap_node_path 
export(Resource) var tilemap_res 
export(bool) var clear_tilemap setget set_clear_tilemap
export(bool) var load_tilemap setget set_load_tilemap
export(bool) var update_tilemap setget set_update_tilemap
export(int) var edit_tile_heigh = 0
export(bool) var edit_mode setget set_edit_mode
export(Vector2) var square_zero
export(Vector2) var square_size
export(bool) var square_create setget set_square_create 

var tile_tscn: = preload("res://addons/miros/module/TileEditor/TileInstance/Tile.tscn")

const line_slope = 0.5 
const line_length = 2560
const line_count = 40
const tile_width = 64
const tile_heigh = 32
const tile_layer_heigh = 16

func _process(delta):
	update()
	if edit_mode:
		edit()

# 绘制辅助线
func _draw():
	if Engine.is_editor_hint():
		var xfrom = Vector2(-line_length,-line_slope*line_length)
		var xto = Vector2(line_length,line_slope*line_length)
		var yfrom = Vector2(-line_length,line_slope*line_length)
		var yto = Vector2(line_length,-line_slope*line_length)	
		for i in range(line_count):
			draw_line(xfrom+Vector2(i*tile_width,0),xto+Vector2(i*tile_width,0),Color.gray,1.0)
			draw_line(yfrom+Vector2(i*tile_width,0),yto+Vector2(i*tile_width,0),Color.gray,1.0)
			
			draw_line(xfrom-Vector2(i*tile_width,0),xto-Vector2(i*tile_width,0),Color.gray,1.0)
			draw_line(yfrom-Vector2(i*tile_width,0),yto-Vector2(i*tile_width,0),Color.gray,1.0)
		draw_line(xfrom,xto,Color.red,2.0)
		draw_line(yfrom,yto,Color.yellowgreen,2.0)

# 清除tilemap,从场景和节点
func set_clear_tilemap(value):
	if value == false:return
	clear_tilemap_res()
	var tp = get_node(tilemap_node_path)
	for node in  tp.get_children():node.queue_free()
	clear_tilemap = false
	
# 加载tilemap
func set_load_tilemap(value):
	if value == false:return
	load_tilemap_res()
	load_tilemap = false
	
# 更新tilemap，获取tile自身高度更新显示，并更新Res数据
func set_update_tilemap(value):
	if value == false:return
	var tp = get_node(tilemap_node_path)
	for node in  tp.get_children():node.queue_free()
	var data = tilemap_res.data
	for key in data:
		data[key] = unit_to_cartesian(key)
	save_tilemap_res()
	load_tilemap_res()
	update_tilemap = false

# 矩形生成
func set_square_create(value):
	if value == false:return
	for i in  range(square_size.x):
		for j in range(square_size.y):
			#如果此位置已有tile,则继续
			var pos_iso =square_zero+Vector2(i,j)
			var pos_unit = Vector3(pos_iso.x,pos_iso.y,0)
			if is_has_tile_in_tilemap_res(pos_unit):continue
			create_tile(pos_unit)
	square_create = false

func cartesian_to_isometric(pos:Vector2)->Vector2:
	var x = pos.x/tile_width + pos.y/tile_heigh
	var y = -pos.x/tile_width + pos.y/tile_heigh
	return Vector2(floor(x),floor(y))

func isometric_to_cartesian(pos:Vector2):
	var x = tile_width/2*pos.x - tile_width/2*pos.y
	var y = tile_heigh/2*pos.x + tile_heigh/2*pos.y
	return Vector2(x,y)

func unit_to_cartesian(pos:Vector3):
	var pos_iso = Vector2(pos.x,pos.y)
	var heigh = pos.z
	var pos_car = isometric_to_cartesian(pos_iso)-Vector2(0,tile_layer_heigh*heigh)
	return pos_car

func set_edit_mode(value):
	edit_mode = value

# 编辑模式
func edit():
	if Input.is_mouse_button_pressed(2):
		var pos_iso = get_mouse_pos_isometric_pos()
		#如果此位置已有tile,则返回
		if is_has_tile_in_tilemap_res(pos_iso):return
		create_tile(pos_iso)
	elif Input.is_mouse_button_pressed(3):
		var pos_iso = get_mouse_pos_isometric_pos()
		#如果此位置已有tile,则删除此Tile返回
		if is_has_tile_in_tilemap_res(pos_iso):
			delete_tile(pos_iso)

# 创建tile
func create_tile(pos:Vector3):
	var tile = tile_tscn.instance()
	get_node(tilemap_node_path).add_child(tile)
	tile.set_owner(get_tree().get_edited_scene_root())
	tile.pos_unit = pos
	tile.position = unit_to_cartesian(pos)
	tile.set_z_index(pos.x + pos.y)
	tile.set_name("tile_"+str(pos.x)+"_"+str(pos.y))
	add_tile_to_tilemap_res(pos,tile.position)

# 获取鼠标位置的等距坐标
func get_mouse_pos_isometric_pos()->Vector2:
	return  cartesian_to_isometric(get_global_mouse_position())

# 获取指定等距位置tile的节点路径
func get_tile_path_from_scene(pos:Vector3):
	var tiles = get_node(tilemap_node_path).get_children()
	for tile in tiles:
		if tile.pos_unit == pos:
			return tile.get_path()

# 判断tilemap资源中是否有指定等距位置tile
func is_has_tile_in_tilemap_res(pos:Vector3)->bool:
	return tilemap_res.data.has(pos)

# 加载tilemap资源
func load_tilemap_res():
	var tilemap_build = tilemap_res.data
	if tilemap_build.size() == 0:return
	for key in tilemap_build:
		var tile = tile_tscn.instance()
		get_node(tilemap_node_path).add_child(tile)
		tile.set_owner(get_tree().get_edited_scene_root())
		tile.position = tilemap_build[key][0]
		tile.z_index = key.x + key.y
		tile.set_name("tile_"+str(key.x)+"_"+str(key.y))
		
# 保存tilemap资源数据
func save_tilemap_res():
	ResourceSaver.save(tilemap_res.resource_path,tilemap_res)

# 清除tilemap资源数据
func clear_tilemap_res():
	tilemap_res.data.clear()
	save_tilemap_res()

# 删除在场景和资源中指定等距位置tile，
func delete_tile(pos:Vector3):
	get_node(get_tile_path_from_scene(pos)).queue_free()
	remove_tile_from_tilemap_res(pos)

# 添加tile到tilemap资源里
func add_tile_to_tilemap_res(key,value):
	tilemap_res.data[key] = value
	save_tilemap_res()

# 删除tilemap资源中指定等距位置tile
func remove_tile_from_tilemap_res(key):
	tilemap_res.data.erase(key)
	save_tilemap_res()
