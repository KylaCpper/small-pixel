extends Node
var Load=0
var Seed=0
var SetData={
	"sound":{"music":100,"effect":100},
	"gui":{"op":100,"bar":0},
	"language":1
	
}
var _thread=[0,0]
var thread=[0,0]
var map={}
var map_data={}
var map_bg={}
var map_bg_data={}
var SaveData=0
var textures={}
var SaveName=null
var anms={}
var scenes={}
var shift=0
var mode=0
var script={}
var cmd=0
var select=null
var vec=[
	Vector2(-32,0),
	Vector2(0,32),
	Vector2(32,0),
	Vector2(0,-32)
]
var vec_op=[
	"right",
	"up",
	"left",
	"down"
]
var player={
	"health":{"val":10,"max":10},
	"oxygen":{"val":10,"max":10},
	"food":{"val":10,"max":10,"time":120},
	"water":{"val":10,"max":10,"time":120},
	"animal":{"val":10,"max":10,"time":200},
	"plant":{"val":10,"max":10,"time":150}
}
var weather="sunny"
#sunny rain
var status_list={
	"hungry":null,
	"thirst":null,
	"parasite":null,
	"weak":null,
	"malnutrition":null,
}
var time={"day":0,"hour":8,"minute":0}

var hand={}
var sound_scene=preload("res://scene/main/sound2d.tscn")
func _ready():
	for name in Config.textures:
		for data in Config.textures[name]:
			if(name=="function_item"):
				name="item"
			textures[data]=load("res://assets/img/"+name+"/"+data+".png")
	textures.bag_bg=preload("res://assets/img/bag/bag_bg.png")
	for name in Config.scenes:
		scenes[name]=load("res://scene/tscn/"+Config.scenes[name]+".tscn")
	scenes["rain"]=load("res://scene/main/rain.tscn")
	scenes["rain_explosion"]=load("res://scene/main/rain_explosion.tscn")
	for name in Config.anms:
		anms[name]=load("res://scene/ani/"+Config.anms[name]+".anm")
#	var num= OS.get_processor_count()
	thread[0]=0
	_thread[0]=Thread.new()
	thread[1]=0
	_thread[1]=Thread.new()
	Function.init_item(hand)
	set_process_input(true)
	set_fixed_process(true)
	pass
func GetData(key):
	return self[key]
func GetSaveData(key):
	return self[key]
func SetSaveData(data,key):
	self[key]=data
func _input(event):
	if(event.is_action_pressed("shift")):
		shift=1
	if(event.is_action_released("shift")):
		shift=0
var sec=0
var rain_time=0
func _fixed_process(delta):
	sec+=delta
	if(sec>=1):
		#min+1
		time.minute+=1
		
		if(time.minute>=25):
			#hour+1
			time.minute=0
			time.hour+=1
			# 下雨
			if(rain_time==0):
				weather="sunny"
				if(randi()%73+0<1):
					rain_time=randi()%12+3
					weather="rain"
				Function.msg_group("bg","_on_weather",weather)
			else:
				rain_time-=1
			if(time.hour>=24):
				time.hour=0
				time.day+=1
		Function.msg_group("canvas","update")
		sec=0