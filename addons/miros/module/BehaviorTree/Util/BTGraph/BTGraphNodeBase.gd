tool
extends GraphNode

# 保存连接该节点的左右节点引用
var left_nodes:Array
var right_nodes:Array

var left_nodes_name:Array
var right_nodes_name:Array

var hint:String 

var graph_core:Node

var node_class:String

var action_name:String 

var action_args:Dictionary

var state:String

var parent_node:String

var children_node:Array

var decorators:Array


func _ready():
	get_node("VBoxContainer/Hint/Content").text = hint
	get_node("VBoxContainer/Action/Name/Content").text = action_name
	get_node("VBoxContainer/State/Content").text = state


# 添加左节点集
func add_left_node(node):
	if  !left_nodes.has(node) and node != null:
		left_nodes.append(node)
		left_nodes_name.append(node.name)

# 添加右节点集
func add_right_node(node):
	if not right_nodes.has(node) and node != null:
		right_nodes.append(node)
		right_nodes_name.append(node.name)

# 移除已删除节点
func remove_node(node):
	if left_nodes.has(node):
		left_nodes.erase(node)
	if right_nodes.has(node):
		right_nodes.erase(node)

func set_action_name(v):
	action_name = v
	get_node("VBoxContainer/Action/Content").text = action_name


# 根据保存的left_nodes和right_nodes构建连接
func connect_all_node():
	var graph:GraphEdit = graph_core.graph
	for l in left_nodes:
		if !graph.is_node_connected(l.name,0,name,0):
			graph.connect_node(l.name,0,name,0)
	for r in right_nodes:
		if !graph.is_node_connected(name,0,r.name,0):
			graph.connect_node(name,0,r.name,0)

func add_child_node(_name:String):
	children_node.append(_name)
	
func remove_child_node(_name:String):
	children_node.erase(_name)

func has_child_node(_name:String)->bool:
	return children_node.has(_name)

func add_decorator(_name:String):
	decorators.append(_name)

func remove_decorator(_name:String):
	decorators.erase(_name)

func has_decorator(_name:String)->bool:
	return decorators.has(_name)

func set_parent_node(_name:String):
	parent_node = _name

func clear_children_node():
	children_node.clear()


func _on_GraphNode_resize_request(new_minsize):
	rect_size = new_minsize

func _on_Content_text_changed(new_text):
	hint = new_text


	
