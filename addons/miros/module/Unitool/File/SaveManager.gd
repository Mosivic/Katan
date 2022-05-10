extends Node
class_name SavaManager

## 文件是否存在
## @path 文件路径
static func exists_file(path: String) -> bool:
	var file = File.new()
	var exists = file.file_exists(path)
	file.close()
	return exists


## 保存数据
## @path 文件路径
## @data 数据
static func SaveData(path: String, data) -> void:
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(data)	# 写入数据
	file.close()


## 加载数据
## @path 文件路径
## @return 返回数据
static func LoadData(path: String):
	var file = File.new()
	file.open(path, File.READ)
	var data = file.get_var()	# 读取数据
	file.close()
	return data 


## 保存为Json文件
## @file_name 文件名
## @folder_path 保存的文件夹路径
## @data 字典数据
static func SaveDictAsJson(path:String,data:Dictionary):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()

# 读取Json文件,并返回为字典
static func LoadJsonAsDict(path:String):
	var file = File.new()
	if not file.file_exists(path):
		print("Miros:SaveManager:LoadJsonAsDict:文件不存在")
	file.open(path, File.READ)
	var data = JSON.parse(file.get_as_text()).result
	file.close()
	return data


## 解析 csv 文件
## @path 文件路径
## @key 以数据中的哪个值作为 key 值记录到字典中
## @return 以第一行数据作为 key 值，记录成字典形式
static func ParseCsvFile(path: String, key: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)

	# 没有数据则返回空字典
	# 以 ; 分号进行分隔，具体需要自己打开 csv 文件查看是那种字符进行分隔的
	var temp = file.get_csv_line(";")
	if temp.size() <= 1:
		return {}

	# 第一行做为 key
	var keys = []
	for i in temp:
		keys.push_back(i)

	# 读取一行，但不对数据进行操作（这样等于是跳过了这一行）
	# 如果第二行就是要读取的数据，那么就不必加这一行代码
	file.get_csv_line()

	# 获取数据记录到字典中，字典可以方便的获取每个数据
	# 比如我们以数据的名字那一列作为 key 值
	# 那么我们只用通过 名字 来获取那一行数据
	var data_list = {}
	var err_count = 0	# 数据错误次数
	temp = file.get_csv_line(";")
	while temp.size() > 1:
		# 数据列数和 key 数量不一致，则跳过
		if temp.size() != keys.size():
			err_count += 1
			if err_count > 10:	# 错误超过 10 次，则不再读取
				break
			temp = file.get_csv_line(";")
			print_debug("数据有误，与第一行不一致 n: %d, k: %d" % [temp.size(), keys.size()])
			continue

		# 每行数据保存到字典中
		var data = {}
		for idx in range(temp.size()):
			data[keys[idx]] = temp[idx]
		data_list[data[key]] = data

		# 读取下一行数据
		temp = file.get_csv_line(";")

	file.close()
	return data_list 

# 获取指定目录下的所有文件路径
static func GetFilesInDirectory(files:Dictionary,path:String,retain_postfix:bool=true,assign_postfix:String="")->Dictionary:
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and not file_name.begins_with("."):
				files = GetFilesInDirectory(files,path+file_name,retain_postfix,assign_postfix)
			else:
				if !file_name.begins_with("."):
					# 为子目录路径添加“/"
					if !path.ends_with("/"):
						path = path + "/"
					# 保存在字典中
					# 获取后缀，以.区分名称与后缀
					var result = file_name.split(".")
					if assign_postfix == "" or assign_postfix == result[1]:
						if retain_postfix:
							files[file_name] = path + file_name
						else:
							files[result[0]] = path + file_name
			file_name = dir.get_next()
	else:
		print("SaveManager:GetFilesDirectory:Can not open dir.")
	return files

