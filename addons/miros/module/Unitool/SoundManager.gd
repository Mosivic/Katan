### 声音管理器v0.1 By Mosiv 2022.4.21
### 管理声音的播放
###

extends AudioStreamPlayer
class_name SoundManager

# 声音列表
var sounds:Dictionary = {}


# 添加声音
func AddSound(name:String,path:String):
	if isExistSoundByName(name) == false:
		sounds[name] = path
	else:
		print("SoundManager:AddSound:声音已存在")

# 添加声音组
func AddSoundList(name:String,sounds_array:Array):
	if isExistSoundByName(name) == false:
		sounds[name] = sounds_array
	else:
		print("SoundManager:AddSoundList:声音已存在")
	

# 播放声音
func PlaySound(name:String):
	if sounds.has(name):
		if typeof(sounds[name]) == TYPE_STRING:
			stream = load(sounds[name])
		elif typeof(sounds[name]) == TYPE_ARRAY:
			var i = randi()%len(sounds[name])
			stream = load(sounds[name][i])
		play()
	else:
		print("SoundManager:PlaySound:声音不存在")

# 检查声音是否存在
func isExistSoundByName(name:String)->bool:
	return sounds.has(name)
