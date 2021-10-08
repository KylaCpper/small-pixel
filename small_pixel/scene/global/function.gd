extends Node
var player
func _ready():
	pass
func GetSaveDataRow(filename,pwd=null):
	var file = File.new()
	if(!file.file_exists("user://"+filename)):return 0
	if(!pwd):
		file.open("user://"+filename, File.READ)
	else:
		file.open_encrypted_with_pass("user://"+filename, File.READ,pwd)
	if(!file):return 0
	var data={}
	var data_be=file.get_line()
	
	data.parse_json(data_be)
	file.close()
	return data
	pass
func SetSaveDataRow(filename,data,pwd=null):
	var file = File.new()
	if(!pwd):
		file.open("user://"+filename, File.WRITE)
	else:
		file.open_encrypted_with_pass("user://"+filename, File.WRITE,pwd)
	if(!file):return
	for i in range(data.size()):
		file.store_line(data[i])
	file.close()
	pass
func GetSaveData(filename,pwd=null):
	var file = File.new()
	if(!file.file_exists("user://"+filename)):return 0
	if(!pwd):
		file.open("user://"+filename, File.READ)
	else:
		file.open_encrypted_with_pass("user://"+filename, File.READ,pwd)
	if(!file):return 0
	var data=[]
	var index=0
	while 1:
		var data_be=file.get_line()
		if(data_be):
			data.append({})
			data[index].parse_json(data_be)
			index+=1
		else:
			break
	file.close()
	return data[data.size()-1]
func SetSaveData(filename,data,pwd=null):
	var file = File.new()
	if(!pwd):
		file.open("user://"+filename, File.WRITE)
	else:
		file.open_encrypted_with_pass("user://"+filename, File.WRITE,pwd)
	if(!file):return
	if(data!=0):
		if("time" in data):
			file.store_line(data.time.to_json())
		file.store_line(data.to_json())
	file.close()
	pass
func get_dir(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var files=[]
		var folders=[]
		while (file_name != ""):
			if dir.current_is_dir():
				folders.append(file_name)
			else:
				files.append(file_name)
			file_name = dir.get_next()
		return {"files":files,"folders":folders}
	else:
		return 0
func hand_distance(player_pos=player.get_pos(),mode=1):
	var pos=OverallGui.that.get_global_mouse_pos()-player_pos
	if(mode==1):
		if((abs(pos.x)<200)&&(abs(pos.y)<200)):
			return 1
		return 0
	if((abs(pos.x)<200)&&(abs(pos.y)<200)):
		if((abs(pos.x)>25)||(abs(pos.y)>50)):
			return 1
	return 0
func hand_distance_use(obj):
	var player_pos=player.get_pos()
	var pos=OverallGui.that.get_global_mouse_pos()-player_pos
	var ray=player.get_node("hand")
	if((abs(pos.x)<200)&&(abs(pos.y)<200)):
		ray.set_cast_to(obj.get_pos()-player_pos)
		var obj_c=ray(ray,ray.get_pos())
		if obj_c:
			if obj_c.get_instance_ID()==obj.get_instance_ID():
				return 1
			else:
				return 0
		return 1
	return 0
func clear_item(item):
	item.name=null
	item.num=0
	item.health=0
func give_item(item1,item2):
	item1.name=item2.name
	item1.num=item2.num
	item1.health=item2.health
func init_item(item):
	for key in Config.item:
		item[key]=Config.item[key]
func is_queue_free(obj):
	var wr = weakref(obj)
	var data=0
	if (!wr.get_ref()):
		data=1
	wr=null
	return data
func ray(ray,pos):
	ray.set_pos(pos)
	ray.force_raycast_update()
	if(ray.is_colliding()):
		var obj=ray.get_collider()
		if(obj.is_queued_for_deletion()):
			return null
		else:
			return obj
	else:
		return null
func msg_group(group,function,arg0=null,arg1=null,arg2=null,arg3=null,arg4=null):
	get_tree().call_group(0,group,function,arg0,arg1,arg2,arg3,arg4)