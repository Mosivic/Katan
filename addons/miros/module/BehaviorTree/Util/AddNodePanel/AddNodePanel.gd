tool
extends PanelContainer

const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")

var _plugin:EditorPlugin

onready var hbox = $ScrollContainer/HBoxContainer

func set_plugin(value:EditorPlugin):
	_plugin = value
	if not self.is_inside_tree():
		yield(self,"ready")
	
	for key in BTClassBD.BTNodeClass.keys():
		var b = Button.new()
		b.set_meta("bt_data",{
			script = BTClassBD.BTNodeClass[key] ,
			name = key,
		})
		b.text = key
		b.connect("pressed",self,"_on_Button_pressed",[b])
		b.icon = _plugin.get_editor_interface().get_base_control().get_icon("Node","EditorIcons")
		b.rect_min_size = Vector2(100,40)
		hbox.add_child(b)

func _on_Button_pressed(button:Button):
	var data = button.get_meta("bt_data")
	var bt_node = data.script.new() as Node
	bt_node.name = data.name
	
	## 获取选择节点, 加入
	var nodes = _plugin.get_editor_interface().get_selection().get_selected_nodes()
	if nodes.size() > 0:
		nodes[0].add_child(bt_node,true)
		bt_node.owner = nodes[0].owner if nodes[0].owner != null else nodes[0]
	else:
		print("没有选中节点.")


