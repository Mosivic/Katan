# 挂载在一个结点下，称之为宿主
# 方法只由宿主使用
extends Node

# 函数类型
const FUNC_TYPE = {
	NULL = 0,
	SHOT = 1,
	SHOT_OVER = 2,
	PROCESS = 3,
	PHYSICS_PROCESS = 4
}

const STATE_OP_MODE ={
	NULL = 0,
	ADD = 1,
	REMOVE = 2,
	REPLACE = 3,
}

signal state_changed

# 状态列表
export(Array) var states
# 当前状态 为状态列表中n(n>=1)个的组合
var currrent_state:Array
# 状态函数列表
var state_functions:Array

var shot_over_pipeline:Array
# 处理管线
var process_pipeline:Array
var physics_process_pipeline:Array
# 扩展是否能够进行状态改变
var is_change_active:bool = true


func _ready():
	connect("state_changed",self,"state_listener")

func _process(delta):
	if process_pipeline.empty():return
	lanch_constant_pipeline(false)

func _physics_process(delta):
	if physics_process_pipeline.empty():return
	lanch_constant_pipeline(true)


func lanch_constant_pipeline(is_physics:bool = false):
	var pipeline = physics_process_pipeline if is_physics else process_pipeline
	for task in pipeline:
		var func_ref:FuncRef = task["func"]
		func_ref.call_func()

func launch_shot_pipeline(pipeline:Array):
	if pipeline.empty():return
	for task in pipeline:
		var func_ref:FuncRef = task["func"]
		func_ref.call_func()


func state_listener(state:Array,mode:int):
	if mode == STATE_OP_MODE.NULL:return
	var pipelines = acquire_pipelines(state)
	match mode:
		STATE_OP_MODE.ADD:
			var shot_pipeline = pipelines[FUNC_TYPE.SHOT]
			add_state(state)
			add_constant_pipeline(pipelines)
			add_shot_over_pipeline(pipelines[FUNC_TYPE.SHOT_OVER])
			
			launch_shot_pipeline(shot_pipeline)
		STATE_OP_MODE.REMOVE:
			var over_pipeline = pipelines[FUNC_TYPE.SHOT_OVER]
			remove_state(state)
			remove_constant_pipeline(pipelines)
			remove_shot_over_pipeline(pipelines[FUNC_TYPE.SHOT_OVER])
			
			launch_shot_pipeline(over_pipeline)
		STATE_OP_MODE.REPLACE:
			launch_shot_pipeline(shot_over_pipeline)
			clear_constant_pipeline()
			shot_over_pipeline.clear()
			
			var shot_pipeline = pipelines[FUNC_TYPE.SHOT]
			replace_state(state)
			add_constant_pipeline(pipelines)
			add_shot_over_pipeline(pipelines[FUNC_TYPE.SHOT_OVER])
			
			launch_shot_pipeline(shot_pipeline)

func add_constant_pipeline(pipelines:Dictionary):
	for p in pipelines[FUNC_TYPE.PROCESS]:
		process_pipeline.append(p)
	for p in pipelines[FUNC_TYPE.PHYSICS_PROCESS]:
		physics_process_pipeline.append(p)

func remove_constant_pipeline(pipelines:Dictionary):
	for p in pipelines[FUNC_TYPE.PROCESS]:
		process_pipeline.erase(p)
	for p in pipelines[FUNC_TYPE.PHYSICS_PROCESS]:
		physics_process_pipeline.erase(p)

func add_shot_over_pipeline(pipeline:Array):
	for e in pipeline:
		shot_over_pipeline.append(e)

func remove_shot_over_pipeline(pipeline:Array):
	for e in pipeline:
		shot_over_pipeline.erase(e)

func clear_constant_pipeline():
	process_pipeline.clear()
	physics_process_pipeline.clear()

func add_state(state):
	for e in state:
		currrent_state.append(e)

func remove_state(state:Array):
	for e in state:
		currrent_state.erase(e)

func replace_state(state:Array):
	currrent_state = state

# 添加单个状态进入当前状态
func add_single_state(_state:String):
	if not is_change_active:return
	if currrent_state.has(_state):
		return
	emit_signal("state_changed",[_state],STATE_OP_MODE.ADD)


# 移除当前状态中的单个状态
func remove_single_state(_state:String):
	if not is_change_active:return
	if not currrent_state.has(_state):
		return
	emit_signal("state_changed",[_state],STATE_OP_MODE.REMOVE)


# 改变当前状态
func change_state(_state:Array):
	if not is_change_active:return
	emit_signal("state_changed",_state,STATE_OP_MODE.REPLACE)


# 配置处理管线
func acquire_pipelines(state:Array)->Dictionary:
	var pipelines := {
		FUNC_TYPE.NULL: [],
		FUNC_TYPE.SHOT: [],
		FUNC_TYPE.SHOT_OVER: [],
		FUNC_TYPE.PROCESS: [],
		FUNC_TYPE.PHYSICS_PROCESS: []
	}
	for e in state_functions:
		var is_wrapped = is_arry_been_wrapped(state,e["state"])
		if not is_wrapped: continue
		
		var func_type = e["type"]
		pipelines[func_type].append(e)
	return pipelines


# 判断一数组元素是否为另一数组的子集
func is_arry_been_wrapped(wrap:Array,inner:Array)->bool:
	for e in inner:
		if not wrap.has(e):
			return false
		else:
			continue
	return true

# 设置状态函数
func set_state_func(_func:FuncRef,_state:Array,func_type = FUNC_TYPE.SHOT):
	var e = {
		"state":_state,
		"func":_func,
		"type":func_type
	}
	state_functions.append(e)


func lock_state():
	is_change_active = false

func unlock_state():
	is_change_active = true
