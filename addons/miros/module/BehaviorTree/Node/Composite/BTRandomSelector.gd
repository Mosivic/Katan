extends "BTCompositeBase.gd"


# 随机执行子结点行为
# 将随机数字保存在action_args中，行为执行成功或失败后擦除该数据
static func _task(e:BTEngine,is_physics:bool,delta)->int:
	var node_data = e.current_node_data
	var action = node_data["action"]

	var children_node = node_data["children_node"]
	var children_count = children_node.size()
	if children_count == 0:
		return STATE.TASK_STATE.FAILED
	
	var action_state:int = 0
	
	if !action.action_temp.has("seleted_node_data"):
		randomize()
		var random_index = randi() % children_count
		var selected_node_name = children_node[random_index]
		var selected_node_data = e.Get_node_data_by_name(selected_node_name)
		action.action_temp["seleted_node_data"] = selected_node_data
	else:
		var selected_node_data = action.action_temp["seleted_node_data"]
		var selected_node_action = selected_node_data["action"]
		action_state = action_execute(action,is_physics,delta)
	return wrap(e,[action_state])
