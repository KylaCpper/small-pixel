extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var function
var overall
onready var SetData=Overall.SetData


var language_key
var language_id=0
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	language_key=Config.GetConfig("LanguageArr")
	get_node("close").connect("pressed",self,"_on_close_press")
	get_node("sure").connect("pressed",self,"_on_sure_press")
	
	get_node("music bar").connect("value_changed",self,"_on_music_change")
	get_node("effect bar").connect("value_changed",self,"_on_effect_change")
	get_node("gui bar").connect("value_changed",self,"_on_gui_change")
	get_node("gui_bar check").connect("toggled",self,"_on_gui_check")
	
	get_node("language list").connect("item_selected",self,"_on_language_select")
	"""
	var data=Function.GetSaveData("set.save")
	if(data==0):
		Function.SetSaveData("set.save",SetData)
		data=SetData
	Overall.SetSaveData(data,"SetData")
	"""
	for key in Config.GetConfig("LanguageString"):
		get_node("language list").add_item(key)
	language_id=Overall.SetData.language
	get_node("language list").select(language_id)
	#overall.SetSaveData(data,"SetData")
	set_bar()
	pass
func _on_close_press():
	set_bar()
	set_language_list()
	get_tree().call_group(0,"home","close_other_window","set")
	pass
func _on_sure_press():
	###sound
	SetData.sound.music=get_node("music bar").get_val()
	SetData.sound.effect=get_node("effect bar").get_val()
	SetData.gui.op=get_node("gui bar").get_val()
	SetData.gui.bar=bar
	#set sound
	###
	###language
	
	SetData.language=language_id
	TranslationServer.set_locale(language_key[language_id])
	###
	#save data
	Function.SetSaveData("set.save",SetData)

	Global.GoTo_Scene("res://scene/start/start.tscn")
	
	
func _on_music_change(val):
	get_node("music bar/text").set_text(str(int(val)))
	pass
func _on_effect_change(val):
	get_node("effect bar/text").set_text(str(int(val)))
	pass
func _on_gui_change(val):
	get_node("gui bar/text").set_text(str(int(val)))
var bar=0
func _on_gui_check(be):
	if(be):
		bar=1
	else:
		bar=0
func set_bar():
	get_node("music bar").set_val(SetData.sound.music)
	get_node("effect bar").set_val(SetData.sound.effect)
	get_node("gui bar").set_val(SetData.gui.op)
	get_node("gui_bar check").set_pressed(SetData.gui.bar)
	bar=SetData.gui.bar
	
	
func set_language_list():
	language_id=Overall.SetData.language
	get_node("language list").select(language_id)
func _on_language_select(index):
	language_id=index