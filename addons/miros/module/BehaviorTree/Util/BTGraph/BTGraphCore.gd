tool
extends Control

onready var file_dialog:FileDialog = get_node("./UI/FileDialog")
# 行为树Graph
onready var graph = $GraphEdit
# UI
onready var ui = $UI
# 动作数据库
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")
# 行为树类数据库
const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")
#
const BTGraphNodeAssembler = preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTGraphNodoAssembler.gd")
# 行为树节点
var bt_gragh_node = preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTGraphNode.tscn")
# 插件类引用
var _plugin:EditorPlugin
# Graph数据，key为node名称，value为node信息
var graph_data = {}
# Graph中被选中的GraphNode
var selected_node:GraphNode
# 
var parent_node:String = "Root"
#
var children_node:Array
# 当前层级
var current_layer:String = parent_node

func set_plugin(value:EditorPlugin):
	_plugin = value
	if not self.is_inside_tree():
		yield(self,"ready")
	ui.init(self)
	ui._set_path()
	_clear_graph()


#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Data Operation / 图数据操作

# Pack node_info from Node 封装结点数据 - 用于保存结点数据
func _pack_node_info(node)->Dictionary:
	var data = {
		"name":node.name,
		"hint":node.hint,
		"node_class":node.node_class,
		"parent_node":node.parent_node,
		"children_node":node.children_node,
		"left_nodes_name":node.left_nodes_name,
		"right_nodes_name":node.right_nodes_name,
		"offset":node.offset,
		"action_name":node.action_name,
		"action_args":node.action_args,
		"decorators":node.decorators
	}
	return data

# Build Node from node_info / 解包结点并赋值数据到结点实例 - 用于还原结点
func _unpack_node_info(node,info:Dictionary):
	if !info.has("node_class"):
		info.node_class = "Root"
	if !info.has("name"):
		info.name = info.node_class + "_" +str(node.get_instance_id())
	if !info.has("hint"):
		info.hint = ""
	if !info.has("parent_node"):
		info.parent_node = current_layer
	if !info.has("children_node"):
		info.children_node = []
	if !info.has("left_nodes_name"):
		info.left_nodes_name = []
	if !info.has("right_nodes_name"):
		info.right_nodes_name = []
	if !info.has("offset"):
		info.offset = Vector2.ZERO
	if !info.has("action_name"):
		info.action_name = "ActionEmpty"
	if !info.has("action_args"):
		info.action_args = {}
	if !info.has("decorators"):
		info.decorators = []
	node.name = info.name
	node.hint = info.hint
	node.node_class = info.node_class
	node.parent_node = info.parent_node 
	node.children_node = info.children_node
	node.left_nodes_name = info.left_nodes_name
	node.right_nodes_name = info.right_nodes_name
	node.offset = info.offset
	node.action_name = info.action_name
	node.action_args = info.action_args
	node.decorators = info.decorators


# Generate graph_data from Graph / 从结点实例，生成图数据graph_data
func _make_graph_data():
	if graph.get_child_count() == 0:return
	graph_data.clear()
	for node in graph.get_children():
		if not node is GraphNode:continue
		var info = _pack_node_info(node)
		graph_data[node.name] = info

# Load Graph from graph_data / 从数据中加载图
# 创建结点实例，并解包数据赋值实例上
# 设定其父节点
# 创建结点建连接
# 跳转到根图上
# 渲染结点树
func _load_graph_from_data():
	for node_data in graph_data.values():
		var node = _create_node(node_data)
	for child in graph.get_children():
		if child is GraphNode:
			_set_parent_to_child(child)
	# 创建结点间连接
	for node_data in graph_data.values():
		var node_name = node_data["name"]
		# 创建左连接
		for l in node_data["left_nodes_name"]:
			_on_GraphEdit_connection_request(l,0,node_name,0)
		# 创建右连接
		for r in node_data["right_nodes_name"]:
			_on_GraphEdit_connection_request(node_name,0,r,0)
	_jump_graph(parent_node)
	ui._build_tree()

# 保存数据检查
# 根图和子图中只能存在一个Root结点
func _save_data_check()->bool:
	return true

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Operate Graph instance node / 操作图中结点

# 创建新结点
# 创建结点实例， 赋值graph_core， title
# 解包数据赋值于结点实例
# 结点装配器加工结点
# 结点UI生成
func _create_node(info:Dictionary)->Node:
	var node = bt_gragh_node.instance()
	_unpack_node_info(node,info)
	node.graph_core = self
	node.title = node.name
	node = BTGraphNodeAssembler.assemble_node(node)

	# node UI生成
	ui._build_decorators_from_data(node)
	ui._build_action_args_from_data(node)
	
	# node UI事件绑定
	node.find_node("AddBtn").connect("button_down",ui,"_on_action_arg_add_button_down",[node])
	
	graph.add_child(node)
	return node


# Delete appoint node / 删除给定结点
func _delete_node(node:Node):
	if graph.has_node(node.name):
		graph.remove_child(node)
		node.queue_free()

# 设置该结点的父节点与之的子关系
func _set_parent_to_child(node):
	if node.parent_node == parent_node:
		if !children_node.has(node.name):
			children_node.append(node.name)
	else:
		var parent = _get_node_by_name(node.parent_node)
		if !parent.has_child_node(node.name):
			parent.add_child_node(node.name)

# 创建子图
# 隐藏图结点，清除图连接，指定当前结点为parent
func _create_child_graph(parent:String):
	_hide_graph()
	graph.clear_connections()
	var node = _get_node_by_name(parent)
	current_layer = node.name
	ui._set_path()

# 销毁子图
func _delete_child_graph(parent:String):
	if parent == parent_node:
		pass
	else:
		var parent_node = _get_node_by_name(parent)
		for child_name in parent_node.children_node:
			var child_node = _get_node_by_name(parent)
			graph.remove_child(child_node)
			child_node.queue_free()
		parent_node.clear_children_node()

# 跳转到根图或子图
# 判断是否有该子图, 或为根图
# 隐藏图结点，清除图连接，设置当前层级为parent
# 显示当前层级为parent的结点，重新构建连接
func _jump_graph(parent:String):
	if graph.has_node(parent) and graph.get_node(parent).children_node.size() != 0:
		current_layer = parent
	elif parent == parent_node:
		current_layer = parent
	else:
		print_debug("未找到该层级")
		return
	_hide_graph()
	graph.clear_connections()
	for child in graph.get_children():
		if child is GraphNode and child.parent_node == parent:
				child.connect_all_node()
				child.show()

# Destory Graph / 销毁图
func _clear_graph():
	for node in graph.get_children():
		if node is GraphNode:
			graph.remove_child(node)
			node.queue_free()
	graph.clear_connections()
	selected_node = null
	graph.set_selected(null)

# Hide Graph 
func _hide_graph():
	for node in graph.get_children():
		if node is GraphNode:
			node.hide()

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Build Inspector

func _parse_begin(plugin:EditorInspectorPlugin):
	# 创建标题栏
	plugin.add_custom_control(UIBuilder.create_category_header())
	# 创建节点类型选择
	plugin.add_custom_control(HSeparator.new())
	
	var vbox = HBoxContainer.new()
	var dropdown = OptionButton.new()
	for key in BTClassBD.BTNodeClass:
		dropdown.add_item(key)
	vbox.add_child(dropdown)
	var createNodebutton = Button.new()
	createNodebutton.text = "Create"
	createNodebutton.connect("pressed",self,"_on_createNodeButton_pressed",[dropdown])
	createNodebutton.size_flags_horizontal = Control.SIZE_EXPAND + Control.SIZE_SHRINK_END
	vbox.add_child(createNodebutton)
	plugin.add_custom_control(vbox)
	
	plugin.add_custom_control(HSeparator.new())
	# 创建保存与加载按钮
	var hbox = HBoxContainer.new()
	var saveButton = Button.new()
	var loadButton = Button.new()
	saveButton.text = "Save"
	loadButton.text = "Load"
	saveButton.connect("button_down",ui,"_on_SaveBtn_pressed")
	loadButton.connect("button_down",ui,"_on_LoadBtn_pressed")
	hbox.add_child(saveButton)
	hbox.add_child(loadButton)
	plugin.add_custom_control(hbox)
	plugin.add_custom_control(HSeparator.new())
	# 创建构建Actions按钮
	var buildActionsButtion = Button.new()
	buildActionsButtion.text = "Build Actions"
	buildActionsButtion.connect("button_down",self,"build_actions")
	plugin.add_custom_control(buildActionsButtion)
	
	# 显示被选择结点
	if !selected_node == null:
		_parse_begin_node(plugin)

func _parse_begin_node(plugin:EditorInspectorPlugin):
	plugin.add_custom_control(UIBuilder.create_category_header(selected_node.name))

	var dropdown = OptionButton.new()
	for action in ActionBD.Actions:
		dropdown.add_item(action)
	#dropdown.connect("item_selected",self,"_on_item_selected",[dropdown])
	plugin.add_custom_control(dropdown)
	
	var label = Label.new()
	label.text = "Action"
	plugin.add_custom_control(label)
	
	var hbox = HBoxContainer.new()
	label = Label.new()
	label.text = "ActionName"
	var button = Button.new()
	button.text = selected_node.action_name
	hbox.add_child(label)
	hbox.add_child(button)
	plugin.add_custom_control(hbox)

# 刷新Inspector
func refresh_inspecter():
	_plugin.get_editor_interface().inspect_object(self)
	#_plugin.get_editor_interface().get_inspector().refresh()


#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Node Seleted / 图中结点选择

# 选择结点
func _select_node(node):
	selected_node = node
	graph.set_selected(node)

func _on_GraphEdit_node_selected(node):
	_select_node(node)

func _on_GraphEdit_node_unselected(node):
	_select_node(null)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Link Between Nodes / 结点连接

# 连接节点, from为左节点name,to为右节点name
func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graph.connect_node(from, from_slot, to, to_slot)
	_add_node_link_info(from,to)

# 连接完成后各自将对方节点加入到节点信息中
func _add_node_link_info(from:String,to:String):
	var left = _get_node_by_name(from)
	var right = _get_node_by_name(to)
	left.add_right_node(right)
	right.add_left_node(left)

# 获取结点依靠结点名称
func _get_node_by_name(_name:String)->GraphNode:
	var node = graph.get_node(_name)
	if node == null:
		print("BTGraphCore:Can not get node with name: "+_name)
		return node
	else:
		return node
# 解除连接后清楚双方节点的节点信息
func _remove_node_link_info(from:String,to:String):
	var left = _get_node_by_name(from)
	var right = _get_node_by_name(to)
	left.remove_node(right)
	right.remove_node(left)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
