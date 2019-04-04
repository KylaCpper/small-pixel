extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var data={
	"wall":["wall_str"],
	#就是墙壁而已
	"table":["table_str"],
	#电脑桌，上面放满了乱七八糟的东西
	"chaxiao":["chaxiao_str"],
	#没有他电脑就没电了
	"chaxiao1":["chaxiao1_str"],
	#连接插销板的总源头
	"computer":["computer_str"],
	#上面写着small pixel
	"host":["host_str"],
	#电脑主机
	"towel":["towel_str"],
	#上面放着3条毛巾
	"water_tap":["water_tap_str"],
	#花洒
	"water_tap_wall":["water_tap_wall_str"],
	#厕所墙壁
	"carpet":["carpet_str"],
	#一个大号地毯，上面似乎有头皮屑
	"bad":["bad_str"],
	#睡觉的地方
	"chair":["chair_str"],
	#木头板凳，坐久了腰会酸
	"kitchen_item":["kitchen_item_str"],
	#这个难道厨房么？
	"kitchen_wall":["kitchen_wall_str"],
	#厨房的墙壁
	"cabinet":["cabinet_str"],
	#铁柜子，不知道里面装着什么
	"dumbbell":["dumbbell_str"],
	#哑铃，太重了，举不起来
	"unknown":["unknown_str"],
	#未知的东西
	"door":["door_str"],
	#打开的门
	"drainage":["drainage_str"],
	#排水道
	"bathroom_wall":["bathroom_wall_str"],
	#卫生间的墙壁
}
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
var index=0
var name=null
var show=0
func _on_event(name_):
	if(name_ in data):
		name=name_
		index=1
		show=1
		get_node("text").show()
		get_node("text/text").set_text(tr(data[name_][0]))
func _on_continue():
	if(index<data[name].size()):
		get_node("text/text").set_text(tr(data[name][index]))
		index+=1
	else:
		get_node("text").hide()
		index=0
		show=0