# 
# 挂载在一个结点下，称之为宿主
# 方法只由宿主使用
extends Node

export(Dictionary) var custom_property
export(Resource) var data_res

const COMPARE_MODE={
	NULL = 0,
	LESS = 1,
	EQUAL = 2,
	GREATER = 3,
}

const CACULATE_MODE = {
	NULL = 0,
	PLANE = 1,
	SQUARE = 2,
}

var data:Dictionary
var actor:Node

#属性触发器， 当属性的一定条件满足时触发
var property_trigger:Dictionary
#buff，持续性的的属性变化
var buff:Dictionary

var timer:float = 0

func _ready():
	actor = get_parent()
	register_custom_property()

func _process(delta):
	timer += delta
	check_trigger()
	check_buff(delta)
	
func set_custom_property(_name:String,_value:float):
	if data.has(_name):
		data[_name] = _value
	else:
		print("OneData:set_custom_property:Had not find property: "+_name+ " wih actor: "+ actor.name)

func get_custom_property(_name:String):
	if data.has(_name):
		return data[_name]
	else:
		print("OneData:get_custom_property:Had not find property: "+_name+ " wih actor: "+ actor.name)
		return null

func register_custom_property():
	for key in custom_property.keys():
		data[key] = custom_property[key]

func save_data():
	if data_res != null:
		data_res.data = data
		ResourceSaver.save(data_res.resource_path,data_res)
	else:
		print("OneData:save_data() data_res is null with actor: "+ actor.name+ "")

func add_property_trigger(_trigger_name:String,_property_name:String,_valve:float,_compare_mode:int,_recall:FuncRef):
	property_trigger[_trigger_name] = {
		"property_name":_property_name,
		"valve":_valve,
		"compare_mode":_compare_mode,
		"recall":_recall
	}

func remove_property_trigger(_trigger_name):
	if property_trigger.has(_trigger_name):
		property_trigger.erase(_trigger_name)


func check_trigger():
	if property_trigger.size() == 0:return
	for key in property_trigger.keys():
		var property_name = property_trigger[key]["property_name"]
		var valve = property_trigger[key]["valve"]
		var compare_mode = property_trigger[key]["compare_mode"]
		var recall:FuncRef = property_trigger[key]["recall"]
		var property = data[property_name]
		match compare_mode:
			COMPARE_MODE.NULL:
				return
			COMPARE_MODE.EQUAL:
				if property == valve:
					recall.call_func()
			COMPARE_MODE.GREATER:
				if property > valve:
					recall.call_func()
			COMPARE_MODE.LESS:
				if property <  valve:
					recall.call_func()
	return
				
		

func caculate_property(_property_name:String,_value:float,_caculate_mode:int=1):
	var property =  data[_property_name]
	match _caculate_mode:
		CACULATE_MODE.PLANE:
			property += _value
		CACULATE_MODE.SQUARE:
			property *= _value
	data[_property_name] = property
 

func add_buff(_buff_name:String,_property_name:String,_value:float,_interval:float,_last:float,_caculate_mode:int=1,_on_recall:FuncRef=null,_over_recall:FuncRef=null):
	if buff.has(_buff_name):
		var last = buff[_buff_name]["last"]
		var intervel = buff[_buff_name]["intervel"]
		buff[_buff_name]["last"] = last + _last
		buff[_buff_name]["intervel"] = min(intervel,_interval)
	else:
		buff[_buff_name] = {
			"property_name":_property_name,
			"value":_value,
			"intervel":_interval,
			"last":_last,
			"on_recall":_on_recall,
			"over_recall":_over_recall,
			"time":timer,
			"caculate_mode":_caculate_mode
		}
	
func remove_buff(_buff_name:String):
	if buff.has(_buff_name):
		buff.erase(_buff_name)


func check_buff(delta):
	if buff.size() == 0:return
	for key in buff.keys():
		var property_name = buff[key]["property_name"]
		var value = buff[key]["value"]
		var intervel = buff[key]["intervel"]
		var last = buff[key]["last"]
		var on_recall:FuncRef = buff[key]["on_recall"]
		var over_recall:FuncRef = buff[key]["over_recall"]
		var time = buff[key]["time"]
		var caculate_mode = buff[key]["caculate_mode"]
		var property = data[property_name]
		#检查有效时长并设置时长剩余
		if last == -1: #一直存在
			pass
		elif last <= 0: #执行完毕，回调函数
			if over_recall != null:over_recall.call_func()
			return
		else:
			last -= delta
			buff[key]["last"] = last
		#检查是否能执行
		if timer >= time:
			match caculate_mode:
				CACULATE_MODE.PLANE:
					property += value
					data[property_name] = property
				CACULATE_MODE.SQUARE:
					property *= value
					data[property_name] = property
			if on_recall != null:on_recall.call_func()
			#设置下一次执行时间
			buff[key]["time"] = timer + intervel
		else:
			return
		

