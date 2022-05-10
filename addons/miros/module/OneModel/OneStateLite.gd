# 挂载在一个结点下，称之为宿主
# 方法只由宿主使用
extends Node

# 函数类型
const FUNC_TYPE = {
	NULL = 0,
	SHOT = 1,
	PROCESS = 2,
	PHYSICS_PROCESS = 3
}


signal state_changed

# 状态列表
export(Array) var states
# 当前状态 为状态列表中n(n>=1)个的组合
var currrent_state:String
# 状态函数列表
var state_functions:Dictionary

# 处理管线
var process_pipeline:Array
var physics_process_pipeline:Array
# 扩展是否能够进行状态改变
var is_change_active:bool = true

func _ready():
	connect("state_changed",self,"state_listener")

func _process(delta):
	if process_pipeline.empty():return
	lanch_pipeline(false)

func _physics_process(delta):
	if physics_process_pipeline.empty():return
	lanch_pipeline(true)


func lanch_pipeline(is_physics:bool = false):
	var pipeline = physics_process_pipeline if is_physics else process_pipeline
	for task in pipeline:
		var func_ref:FuncRef = task["func"]
		var func_type = task["type"]
		
		func_ref.call_func()
		if func_type == FUNC_TYPE.SHOT:
			pipeline.erase(task)


# 改变当前状态
func change_state(_state:String):
	if not is_change_active:return
	if not state_functions.has(_state):return
	currrent_state = _state
	process_pipeline.clear()
	physics_process_pipeline.clear()
	
	var state_function = state_functions[_state]
	var func_type = state_function["type"]
	
	if func_type == FUNC_TYPE.PHYSICS_PROCESS:
		physics_process_pipeline.append(state_function)
	else:
		process_pipeline.append(state_function)


# 设置状态函数
func set_state_func(_func:FuncRef,_state:String,func_type = FUNC_TYPE.SHOT):
	state_functions[_state] = {
		"func":_func,
		"type":func_type
	}


func lock_state():
	is_change_active = false

func unlock_state():
	is_change_active = true
