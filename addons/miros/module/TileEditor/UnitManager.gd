extends Node

var mount_node:Node

var unit_type_count = 10
var unit_list:Dictionary

func _init():
	init_unit_list()

func init_unit_list():
	for i in range(unit_type_count):
		unit_list[str(i)] = []

func register_unit(type:int,unit):
	unit_list[str(type)].append(unit)

func unregister_unit(type:int,unit):
	(unit_list[str(type)] as Array).erase(unit)

func set_unit_mount(node:Node):
	mount_node = node

func mount(node:Node):
	mount_node.add_child(node)

func is_has_unit_in_pos_unit(pos:Vector3)->bool:
	for key in unit_list:
		var unit_array = unit_list[key]
		for unit in unit_array:
			if unit.pos_unit == pos:return true
	return false

func is_has_unit_in_pos_unit_by_type(type:int,pos:Vector3)->bool:
	var unit_array = unit_list[str(type)]
	for unit in unit_array:
		if unit.pos_unit == pos:return true
	return false

func get_unit_by_name(type:int,name:String):
	var unit_array:Array = unit_list[str(type)]
	for unit in unit_array:
		if unit.name == name:return unit

func get_units_by_type(type:int)->Array:
	return unit_list[str(type)]
	
func get_unit_by_pos_unit(pos:Vector3):
	for key in unit_list:
		var unit_array = unit_list[key]
		for unit in unit_array:
			if unit.pos_unit == pos:return unit



