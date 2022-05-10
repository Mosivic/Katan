extends Node
class_name BTNodeBase

# 运行
static func Run(e:BTEngine,is_physics:bool,delta:float)->int:
	return _task(e,is_physics,delta)

static func Next(e:BTEngine)->String:
	return _next(e)

static func Last(e:BTEngine)->String:
	return _last(e)

# 节点任务
static func _task(e:BTEngine,is_physics:bool,delta:float)->int:
	var node_data = e.current_node_data
	var action = node_data["action"]
	var action_state = action_execute(action,is_physics,delta)
	return wrap(e,[action_state])


# 任务完成后处理
static func wrap(e:BTEngine,states:Array)->int:
	var result:int
	var node_data = e.current_node_data
	var decorators = node_data["decorators"]
	for decorator in decorators:
		states = decorator._decorate(states)

	if is_states_all_succeed(states):
		result = STATE.TASK_STATE.SUCCEED
	elif is_states_has_failed(states):
		result = STATE.TASK_STATE.FAILED
	else:
		result = STATE.TASK_STATE.RUNNING
	return result

static func _last(e:BTEngine)->String:
	var node_data = e.current_node_data
	var last_node_name:String
	if node_data["left_nodes_name"].size() != 0:
		last_node_name = node_data["left_nodes_name"][0]
	else:
		last_node_name = ""
	return last_node_name

static func _next(e:BTEngine)->String:
	var node_data = e.current_node_data
	var next_node_name:String
	if node_data["right_nodes_name"].size() != 0:
		next_node_name = node_data["right_nodes_name"][0]
	else:
		next_node_name = ""
	return next_node_name
	
# 行为执行
static func action_execute(action:ActionBase,is_physics:bool,delta:float)->int:
	var action_state = action.Get_state()
	match action_state:
		STATE.ACTION_STATE.NULL:
			if action.Is_can_execute(): # 可以开始
				action.Execute_before()
				action_state = STATE.ACTION_STATE.RUNNING
			else:
				action_state = STATE.ACTION_STATE.FAILED
		STATE.ACTION_STATE.RUNNING:
			if action.Is_continue_execute(): # 可以继续
				action.Execute(delta,is_physics)
				if action.Is_over_execute(): # 可以结束
					action.Execute_after()
					action_state = STATE.ACTION_STATE.SUCCEED
				else:
					action_state = STATE.ACTION_STATE.RUNNING
		STATE.ACTION_STATE.SUCCEED:
			pass
		STATE.ACTION_STATE.FAILED:
			pass
	action.Set_state(action_state)
	return action_state

# 行为集顺序执行
static func sequence_actions_execute(actions:Array,is_physics:bool,delta:float)->Array:
	var states:Array
	var is_stop = false
	for action in actions:
		if !is_stop:
			var state = action_execute(action,is_physics,delta)
			if state == STATE.ACTION_STATE.SUCCEED or state == STATE.ACTION_STATE.FAILED:
				states.append(state)
			else:
				is_stop = true
		else:
			states.append(STATE.ACTION_STATE.NULL)
	return states
	
# 行为集并行执行
static func parallel_actions_execute(actions:Array,is_physics:bool,delta:float)->Array:
	var states:Array
	for action in actions:
		var state = action_execute(action,is_physics,delta)
		states.append(state)
	return states

static func is_states_all_over(states:Array)->bool:
	for state in states:
		if state == STATE.ACTION_STATE.NULL or state == STATE.ACTION_STATE.RUNNING:
			return false
	return true

static func is_states_all_succeed(states:Array)->bool:
	for state in states:
		if state != STATE.ACTION_STATE.SUCCEED:
			return false
	return true

static func is_states_all_failed(states:Array)->bool:
	for state in states:
		if state != STATE.ACTION_STATE.FAILED:
			return false
	return true

static func is_states_has_failed(states:Array)->bool:
	for state in states:
		if state == STATE.ACTION_STATE.FAILED:
			return true
	return false
	
static func is_states_has_succeed(states:Array)->bool:
	for state in states:
		if state == STATE.ACTION_STATE.SUCCEED:
			return true
	return false
