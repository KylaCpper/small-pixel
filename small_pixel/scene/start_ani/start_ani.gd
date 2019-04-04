extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var cmd
var num=0
var set_data={
	"sound":{
		"music":30,
		"effect":30
	},
	"gui":{
		"op":100,
		"bar":0
	},
	"ea":1,
	"language":1
}
var string="01110011 01101101 01100001 01101100 01101100 01110000 01101001 01111000 01100101 01101100"
func _ready():
	
	cmd=get_node("cmd_ani")
	cmd.connect("finished",self,"_on_init_game")
	#get_node("start game").set_volume(sound.bg/sound_proportion)
	var data=Function.GetSaveData("set.save")
	if(data==0):
		Function.SetSaveData("set.save",set_data)
		data=set_data
	else:
		if(!"gui" in data):
			data["gui"]={
				"op":100,
				"bar":0
			}
		if(!"ea" in data):
			data["ea"]=1
	Overall.SetData=data
	var language_arr=Config.GetConfig("LanguageArr")
	TranslationServer.set_locale(language_arr[data.language])
	AudioServer.set_stream_global_volume_scale(data.sound.effect/100)
	AudioServer.set_fx_global_volume_scale(data.sound.music/100)
#	get_node("key board").set_volume(sound.effect)
#	get_node("sound").set_default_volume(sound.effect) 
#	get_node("start game").set_volume(sound.music)
	set_process_input(true)
	set_fixed_process(true)
	get_node("start game").play()
	get_node("cmd_ani").play("cmd_ani0")
	pass
var start_01=0
var char1=0
var char_length=89
var time=0
func _fixed_process(delta):
	if(start_01):
		if(time>=0.1):
			get_node("cmd/text").add_text(str(string[char1]))
			char1+=1
			if(char1==char_length):
				get_node("cmd/text").add_text("\n")
				char1=0
				time=0
		time+=delta
		
	pass
func _input(event):
	if(event.is_action_pressed("exit")):
		hide()
		_on_start_game()
func _on_init_game():
	cmd.play("cmd_ani1")
	cmd.disconnect("finished",self,"_on_init_game")
	cmd.connect("finished",self,"_on_start_game")
	start_01=1
	pass
func _on_start_game():
	Global.GoTo_Scene("res://scene/start/start.tscn")
	pass

