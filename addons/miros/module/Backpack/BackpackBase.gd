# Backpack Base 
extends PanelContainer
class_name BackpackBase

# 背包数据res
export(Resource) var backpack_res 

# Drag功能
# 开启将 false 改为 true
var is_can_drag_item = true
var holding_item:Dictionary = {}
var item_preview:Node2D

# Item点击事件
# 开启将 false 改为 true
var is_can_click_item = false

# 鼠标当前位置的slot
var focus_slot = null
# 背包当前页，从1开始
var page:int = 1

# 所有index与item对应数据
var index_data:Dictionary


func _ready():
	_init_slots()

func _input(event):
	if is_can_drag_item:
		drag_item(event)


#-------------------------------------------------------------
# Drag功能
# 可以将slot上已有的item（数据体），移动到其他没有item的slot中
func drag_item(event):
	if item_preview == null:
		item_preview = _build_item_preview()
		add_child(item_preview)
	else:
		if item_preview.visible == true:
			item_preview.global_position = get_global_mouse_position()
		else:
			pass
	# 没有拿住，准备拿起
	if holding_item.empty():
		if focus_slot == null:return
		if !_is_slot_has_item(focus_slot):return
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				holding_item = _get_slot_item(focus_slot)
				_set_item_preview(item_preview,holding_item)
				_remove_item_from_custom_slot(focus_slot)
				item_preview.show()
	# 已经拿起，准备放下
	else:
		if focus_slot == null:return
		if _is_slot_has_item(focus_slot):return
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				_set_item_to_custom_slot(focus_slot,holding_item)
				holding_item.clear()
				item_preview.hide()

# 创建item_preview, 决定item_preview的构造，必须以Node2D作为基类型
func _build_item_preview()->Node2D:
	var item_preview = Node2D.new()
	var texture_rect = TextureRect.new()
	texture_rect.name = "TextureRect"
	texture_rect.mouse_filter = MOUSE_FILTER_IGNORE
	item_preview.add_child(texture_rect)
	return item_preview

# 设置item_preview, 作为显示时的效果
func _set_item_preview(_item_preview:Node2D,_item:Dictionary):
	_item_preview.get_node("TextureRect").texture = load(_item["texture"])

#-------------------------------------------------------------
# Slot设置
func _init_slots():
	var container = get_node("GridContainer")
	var slot_count = container.get_child_count()
	var data = backpack_res.data

	for value in data.values():
		var index = value["index"]
		var slot = container.get_child(index)
		index_data[index] = value.duplicate(1)
		if index >= slot_count:
			continue
		else:
			_set_item_to_custom_slot(slot,value)
	# 配置slots事件
	for slot in container.get_children():
		_config_slot_event(slot) 
	
# 配置slot事件
func _config_slot_event(_slot):
	_slot.connect("mouse_entered",self,"_on_slot_mouse_entered",[_slot])
	_slot.connect("mouse_exited",self,"_on_slot_mouse_exited",[_slot])

# slot事件 - 鼠标进入slot
func _on_slot_mouse_entered(_slot):
	focus_slot = _slot

# slot事件 - 鼠标离开slot
func _on_slot_mouse_exited(_slot):
	focus_slot = null

# 设置slot的item并更新UI
func _set_item_to_custom_slot(_slot,_item:Dictionary):
	var index = _slot.get_index()
	index_data[index] = _item.duplicate(1)
	_slot.get_node("TextureButton").texture_normal =load(_item["texture"])
	_slot.get_node("TextureButton/Label").text = str(_item["count"])

# 移除slot的item并更新UI
func _remove_item_from_custom_slot(_slot):
	var index = _slot.get_index()
	index_data.erase(index)
	_slot.get_node("TextureButton").texture_normal = null
	_slot.get_node("TextureButton/Label").text = ""

# 判断slot是否有item
func _is_slot_has_item(_slot)->bool:
	var index = _slot.get_index()
	if index_data.has(index):
		return true
	return false

# 获取到slot的item
func _get_slot_item(_slot)->Dictionary:
	var index = _slot.get_index()
	return index_data[index]
#-------------------------------------------------------------












