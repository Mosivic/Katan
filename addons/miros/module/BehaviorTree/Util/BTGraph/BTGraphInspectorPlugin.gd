extends EditorInspectorPlugin


func can_handle(object):
	if object.has_method("_parse_begin"):
		return true
	return false

func parse_begin(object):
	if object.has_method("_parse_begin"):
		object._parse_begin(self)
	
	

	# var dropdown = OptionButton.new()
	# dropdown.add_item("Heeeee")
	# dropdown.add_item("Hiiiii")
	# add_custom_control(dropdown)

	# var button = Button.new()
	# button.set_text("Create")
	# #add_custom_control(button)
	
	# var sep = HSeparator.new()
	# add_custom_control(sep)
	
	# var contai = HBoxContainer.new()
	# contai.set_anchors_and_margins_preset(Control.PRESET_TOP_WIDE)
	
	
	

	# button.size_flags_horizontal = Control.SIZE_EXPAND + Control.SIZE_SHRINK_END
	
	# add_custom_control(contai)
	

	

