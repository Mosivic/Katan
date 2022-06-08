# 对话气泡
# By Mosiv in 2020.5.19
# 提供两种显示效果
# 1.打字机
# 2.卷轴
extends Position2D

onready var tween = $Tween

onready var text_label = $Anchor/TextLabel
onready var text_bg = $Anchor/TextureRect
onready var magic_label = $Anchor/MagicLabel

enum EFFECT{
	TYPEWRITER,
	SCROLL
}

export(EFFECT) var effect
export(float) var char_time := 0.1
export(Vector2) var char_scale := Vector2(2,2)

export(bool) var is_auto_hide := false
export(float) var hide_time := 0.5

var text_length :int
var text :String
var text_show := ""

func _ready():
	show_text("你好啊,篮子哥,看看你的大篮子!!!")

func show_text(_text:String):
	text = _text
	text_length = text.length()
	text_show = ""
	
	typerwriter_text()
	
# 依次将text中字符加入到显示中
# 计算每个加入字符的大小,再计算其相对位置
# 将magiclabel设置次相对位置, 变化该字符
# 显示所有字符后,清除magiclabel
func typerwriter_text():
	var string_size = Vector2.ZERO
	var old_string_size = Vector2.ZERO
	var char_size = Vector2.ZERO
	var char_position = Vector2.ZERO
	var descent = text_label.get_font("font").get_descent()
	for i in range(text_length):
		text_show += text[i] 
		
		old_string_size = string_size
		string_size = text_label.get_font("font").get_string_size(text_show)
		char_size = Vector2(string_size.x - old_string_size.x,string_size.y)  
		
		char_position.x += char_size.x
		if char_position.x > text_label.rect_size.x:
			char_position.x = char_size.x
			char_position.y += string_size.y + descent
		
		magic_label.rect_position = char_position - Vector2(char_size.x,0)
		magic_label.rect_pivot_offset = char_size/2
		magic_label.text = text[i]
		
		var rect_scale = match_char_scale_size(text[i])
		tween.interpolate_property(magic_label,"rect_scale",rect_scale,Vector2.ONE,char_time,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(char_time),"timeout")
		
		text_label.text = text_show
	magic_label.text = ""
	
func scroll_text():
	pass

func match_char_scale_size(c)->Vector2:
	match c:
		'!':
			return Vector2(3,3)
	return char_scale

