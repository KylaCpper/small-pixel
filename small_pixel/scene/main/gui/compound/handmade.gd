extends "../Compound.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	grid=4
	init()
func compound_key_sort(compound_key):
	compound_key=compound_key.replace(",4",",5")
	compound_key=compound_key.replace(",3",",4")
	if(compound_key.left(1)=="4"):
		compound_key="5"+compound_key.right(1)
	if(compound_key.left(1)=="3"):
		compound_key="4"+compound_key.right(1)
	return compound_key
func _on_compound(index=0):
	var compound_key=""
	var count=0
	if(index==0):
		for i in range(grid):
			if(items[i].name):
				if(count):
					compound_key+=","+str(i+1)+items[i].name
				else:
					compound_key+=str(i+1)+items[i].name
				count+=1
		if(count==1):
			compound_key=compound_key.right(1)
		else:
			compound_key=compound_key_sort(compound_key)
	elif(index==1):
		var one_grid=0
		for i in range(grid):
			if(items[i].name):
				if(count):
					compound_key+=","+str((i+1-one_grid)*1.5)+items[i].name
				else:
					one_grid=i+1
					compound_key+=items[i].name
				count+=1
	else:
		for i in range(grid):
			if(items[i].name):
				if(count):
					compound_key+=","+items[i].name
				else:
					compound_key+=items[i].name
				count+=1
			
	if(compound_key in Config.compound_table):
		out_item[0].name=Config.compound_table[compound_key].name
		out_item[0].num=Config.compound_table[compound_key].num
		if(Config.items_type[out_item[0].name]=="tool"):
			out_item[0].health=Config.tools[out_item[0].name].health
		else:
			out_item[0].health=0
	else:
		if(count==1):
			Function.clear_item(out_item[0])
			return
		if(index!=2):
			_on_compound(index+1)
		else:
			Function.clear_item(out_item[0])
	