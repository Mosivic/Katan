extends Node
class_name UIBuilder

static func create_category_header(title_string: String = "BTGraph Center") -> PanelContainer:
	var title_panel = PanelContainer.new()
	title_panel.set('custom_styles/panel', create_bg_stylebox(1))
	title_panel.set_h_size_flags(3)
	title_panel.set_v_size_flags(3)
	title_panel.rect_min_size = Vector2(0, 55)
	
	var title_container = HBoxContainer.new()
	title_container.set_alignment(1)
	title_panel.add_child(title_container)
	
	var title_texture = TextureRect.new()
	title_texture.set_texture(load("res://addons/miros/resource/Image/icon.svg"))
	title_texture.set_stretch_mode(6)
	title_container.add_child(title_texture)
	
	var title_text = Label.new()
	title_text.set_text(title_string)
	title_container.add_child(title_text)
	
	return title_panel
	
static func create_bg_stylebox(type:int = 1) -> StyleBox:
	var stylebox = StyleBoxFlat.new()
	
	match type:
		1: # Category StyleBox.  Grey w/ green outline
			stylebox.set_bg_color(Color(0.25, 0.27, 0.33, 1))
			stylebox.set_border_width_all(1)
			stylebox.set_border_color(Color(0.65, 0.94, 0.67, 1))
		2: # DropDownContainer StyleBox. Medium light gray
			stylebox.set_bg_color(Color(0.20, 0.22, 0.28, 1))
		3: # Property Label. Mediu Blue
			stylebox.set_bg_color(Color(0.15, 0.17, 0.23, 1))
		4: # Property Value. Navy Blue
			stylebox.set_bg_color(Color(0.13, 0.14, 0.19, 1))
		5: # BoxContainer. Transparent BG w/ light grey border.
			stylebox.set_bg_color(Color(1, 1, 1, 0))
			stylebox.set_border_width_all(1)
			stylebox.set_border_color(Color(0.7, 0.7, 0.7, 1))
	
	return stylebox
