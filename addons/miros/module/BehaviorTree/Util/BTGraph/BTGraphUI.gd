tool
extends Control

# 动作数据库
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")
# 行为树类数据库
const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")

const BTActionArg =  preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTActionArg.tscn")
const BTDecorator = preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTDecorator.tscn")

onready var context_box = $Context/VBoxContainer
onready var context = $Context
onready var path = $Path
onready var tree = $Tree
onready var file_dialog = $FileDialog

var graph_core 

var context_button_db:Dictionary

const FILE_MODE = {
	NULL=0,
	SAVE=1,
	LOAD=2
}
var file_mode = FILE_MODE.NULL


func init(core):
	graph_core = core


func _input(event):
	if event.is_pressed() :
		if event.has_meta("button_index"):
			print("hai")
		if  event.button_index == BUTTON_RIGHT:
			if graph_core.selected_node == null:
				_build_main_context()
			else:
				_build_node_operate_context()

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Tools

# 显示Inspector
func _show_inspector(b:Button):
	graph_core.refresh_inspecter()
	_hide_context()

# 设置按钮图标
func _set_button_icon(b:Button,icon_name:String="Node"):
	b.icon = graph_core._plugin.get_editor_interface().get_base_control().get_icon(icon_name,"EditorIcons")

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

# Build Context - Main 
func _build_main_context():
	_clear_context()
	_generate_context_button("创建结点","_build_create_node_context")
	_generate_context_button("显示Inspector","_show_inspector")
	_show_context()
	
# Build Context - Create Node
func _build_create_node_context(b:Button):
	_clear_context()
	for key in BTClassBD.BTNodeClass:
		_generate_context_button(
			key,
			"_on_create_node_button_pressed",
			"bt_data",
			{
				node_class = key,
			}
		)
	_show_context()

#  Build Context - Node Operation
func _build_node_operate_context():
	_clear_context()
	_generate_context_button("选择行为","_build_choose_action_context")
	_generate_context_button("添加装饰","_add_decoretor_context")
	_generate_context_button("创建子图","_generate_child_graph")
	_generate_context_button("进入子图","_enter_child_graph")
	_generate_context_button("删除子图","_delete_child_graph")
	_generate_context_button("删除结点","_on_delete_node_pressed")
	_show_context()

#  Build Context - Choose Actuin
func _build_choose_action_context(b:Button):
	_clear_context()
	for key in ActionBD.Actions:
		_generate_context_button(key,
			"_on_choose_action_button_pressed",
			"bt_data",
			{
				script = ActionBD.Actions[key] ,
				type = key,
			}
		)
	_show_context()

# 清除Context
func _clear_context():
	for c in context_box.get_children():
		context_box.remove_child(c)

# 显示Context
func _show_context():
	context.rect_global_position = get_global_mouse_position()
	context.show()

# 隐藏Context
func _hide_context():
	context.hide()

# 创建结点按钮按下 From Context
func _on_create_node_button_pressed(b:Button):
	var data = b.get_meta("bt_data")
	var node = graph_core._create_node({
		"node_class":data.node_class,
	})
	graph_core._set_parent_to_child(node)
	_hide_context()

# 选择Ation From Context
func _on_choose_action_button_pressed(b:Button):
	if graph_core.selected_node != null:
		graph_core.selected_node.set_action_name(b.text)
	_hide_context()

# 删除结点 From Context
func _on_delete_node_pressed(b:Button):
	graph_core._delete_node(graph_core.selected_node)
	graph_core.selected_node = null
	_hide_context()

# 创建子图 From Context
func _generate_child_graph(b:Button):
	var n = graph_core.selected_node
	graph_core._create_child_graph(n.name)
	graph_core.selected_node = null
	_hide_context()

# 生成上下文按钮 Context Button
func _generate_context_button(text:String,event_name:String="",meta_name:String="",meta_data:Dictionary={},icon_name:String="Node"):
	if context_button_db.has(text) and context_button_db[text]!=null:
		context_box.add_child(context_button_db[text])
		return
	var b = Button.new()
	b.text = text
	b.rect_min_size = Vector2(100,40)
	if meta_name != "":
		b.set_meta(meta_name,meta_data)
	if event_name != "":
		b.connect("button_down",self,event_name,[b])
	_set_button_icon(b,icon_name)
	context_box.add_child(b)
	context_button_db[text] = b



#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# 结点路径 相关

# 添加路径UI
func _set_path():
	for child in path.get_children():
		path.remove_child(child)
		child.queue_free()
	
	var road:Array
	var current_layer = graph_core.current_layer
	while true:
		if current_layer == graph_core.parent_node:
			road.insert(0,current_layer)
			break
		else:
			var n = graph_core._get_node_by_name(current_layer)
			road.insert(0,current_layer)
			current_layer = n.parent_node
	
	for i in road:
		var b = ToolButton.new()
		b.text = i + "/"
		b.connect("button_down",self,"_on_path_button_pressed",[i])
		path.add_child(b)

# 路径按钮按下
# 跳转子图
# 重构路径
# 取消结点选择， 隐藏上下文
func _on_path_button_pressed(parent):
	graph_core._jump_graph(parent)
	graph_core.selected_node = null
	_hide_context()
	_set_path()

# 进入子图按钮按下
# 跳转子图
# 重构路径
# 取消结点选择， 隐藏上下文
func _enter_child_graph(b:Button):
	var n = graph_core.selected_node
	graph_core._jump_graph(n.name)
	graph_core.selected_node = null
	_hide_context()
	_set_path()

#------------------------------------------------------------------------------#
# Action Arg

# node UI 事件
func _on_action_arg_add_button_down(node):
	var input_key_node = node.get_node("VBoxContainer/Action/Args/AddActionArg/Key")
	var input_value_node = node.get_node("VBoxContainer/Action/Args/AddActionArg/Value")
	_build_action_arg(node,input_key_node.text,input_value_node.text)
	input_key_node.text = ""
	input_value_node.text = ""

func _build_action_arg(node,key,value):
	var bt_action_arg = BTActionArg.instance()
	node.action_args[key] = value
	node.get_node("VBoxContainer/Action/Args").add_child(bt_action_arg)
	bt_action_arg.get_node("Key").text = key
	bt_action_arg.get_node("Value").text =value
	bt_action_arg.get_node("DelBtn").connect("button_down",self,"_on_action_arg_del_button_down",[bt_action_arg])

func _build_action_args_from_data(node):
	var action_args = node.action_args
	for key in action_args.keys():
		var bt_action_arg = BTActionArg.instance()
		node.find_node("Args").add_child(bt_action_arg)
		bt_action_arg.get_node("Key").text = key
		bt_action_arg.get_node("Value").text = action_args[key]
		bt_action_arg.get_node("DelBtn").connect("button_down",self,"_on_action_arg_del_button_down",[bt_action_arg])

func _on_action_arg_del_button_down(node):
	var parent = node.get_parent()
	parent.remove_child(node)
	node.queue_free()

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# BTGraphNode Decorator 相关

# 显示Decorator Context
func _add_decoretor_context(b:Button):
	_clear_context()
	for key in BTClassBD.BTDecoratorType:
		_generate_context_button(key,
			"_on_add_decoretor_button_pressed",
			"bt_data",
			{
				script = BTClassBD.BTDecoratorType[key] ,
				type = key,
			}
		)
	_show_context()

# 创建装饰
func _build_decorators_from_data(node):
	var decorators = node.decorators
	for _name in decorators:
		_build_decorator(node,_name)

# 创建装饰
func _build_decorator(node,_name:String):
	var decorator = BTDecorator.instance()
	decorator.get_node("Name").text = _name
	decorator.get_node("Delete").connect("button_down",self,"_on_delete_decorator_button_pressed",[decorator])
	node.add_decorator(_name)
	node.find_node("Decorators").add_child(decorator)

# 添加装饰按钮按下
func _on_add_decoretor_button_pressed(b:Button):
	if graph_core.selected_node != null:
		var decorator_name = b.get_meta("bt_data")["type"]
		var node:Control = graph_core.selected_node
		if node.has_decorator(decorator_name):
			print("装饰已存在，不可反复添加")
			return
		_build_decorator(node,decorator_name)
	_hide_context()

# 删除装饰按钮按下
func _on_delete_decorator_button_pressed(decorater:Control):
	var node = decorater.get_parent().get_parent().get_parent()
	node.find_node("Decorators").remove_child(decorater)
	node.remove_decorator(decorater.get_node("Name").text)
	decorater.queue_free()

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# 结点树 相关

# 建立结点树
# 根据图中结点建立
func _build_tree():
	var root = tree.create_item()
	root.set_text(0,"BTREE")
	root.set_text(1,"结点图")
	_build_tree_part(graph_core,root)

# 建立部分结点树
# 根据给出的开始图建立
func _build_tree_part(current_layer,current_parent_branch):
	for child_name in current_layer.children_node:
		var branch = tree.create_item(current_parent_branch)
		var child_node = graph_core._get_node_by_name(child_name)
		branch.set_text(0,child_name)
		branch.set_text(1,child_node.hint)
		_build_tree_part(child_node,branch)

# TreeCheckButton按下
# 显示或隐藏结点树
func _on_TreeCheckButton_toggled(button_pressed):
	if tree != null:
		tree.set_visible(button_pressed)

# 结点树中item被双击
# 跳转到该item的结点图中，并设置该结点为selected
func _on_Tree_item_activated():
	var item = tree.get_selected() 
	var node_name = item.get_text(0)
	if node_name == "BTREE":return
	var node:GraphNode = graph_core._get_node_by_name(node_name)
	graph_core._jump_graph(node.parent_node)
	graph_core._select_node(node)

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# Filedialog 相关

func _on_SaveBtn_pressed():
	file_dialog.popup_centered()
	file_mode = FILE_MODE.SAVE

func _on_LoadBtn_pressed():
	file_dialog.popup_centered()
	file_mode = FILE_MODE.LOAD

# 文件窗口按下确认事件
func _on_FileDialog_confirmed():
	if file_mode == FILE_MODE.SAVE:
		var path:String = file_dialog.current_path
		if path.split(".")[-1] == "res":
			var res =ResourceLoader.load(path)
			graph_core._make_graph_data()
			res.data = graph_core.graph_data.duplicate(true)
			ResourceSaver.save(path,res)

	elif file_mode == FILE_MODE.LOAD:
		graph_core._clear_graph()
		var path = file_dialog.current_path
		var res = ResourceLoader.load(path)
		if !res.data.size() == 0:
			graph_core.graph_data = res.data.duplicate(true)
			graph_core._load_graph_from_data()
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
