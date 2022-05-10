extends Resource

export(Dictionary) var data ={
	"icon":{
		"name":"icon",
		"texture":"res://icon.png",
		"count":0,
		"index":0
	}
}

# 添加指定数目的item
func add_item(res:Resource,_name,_count:int=1):
	#If had item, update num
	if data.has(_name):
		data[_name]["count"] += _count
	else:
		data[_name] = {
			"name":_name,
			"texture":"res://icon.png",
			"count":_count
		}
	ResourceSaver.save(res.resource_path,res)

# 移除指定数目的item
func remove_item(res:Resource,_name,_count:int=1):
	if _count <= 0 :
		print("传入count数量小于1。")
		return
	if data.has(_name):
		var count = data[_name]["count"]
		var minus = count - _count
		if minus <= 0:
			data.erase(_name)
		else:
			data[_name]["count"] = minus
	else:
		pass
	ResourceSaver.save(res.resource_path,res)

# 移除全部数目的item
func remove_item_all(res:Resource,_name):
	if data.has(_name):
		data.erase(_name)
	ResourceSaver.save(res.resource_path,res)

# 清除data
func clear_data(res:Resource):
	res.data.clear()
	ResourceSaver.save(res.resource_path,res)


