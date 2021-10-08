extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var SetData=Overall.SetData
var language_id=0
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("sure").connect("pressed",self,"_on_sure")
	get_node("return").connect("pressed",self,"_on_return")
	get_node("music/bar").connect("value_changed",self,"_on_music")
	get_node("effect/bar").connect("value_changed",self,"_on_effect")
	get_node("gui/bar").connect("value_changed",self,"_on_gui")
	get_node("bar/check").connect("toggled",self,"_on_bar")
	#language
	for key in Config.LanguageString:
		get_node("language/list").add_item(key)
	get_node("language/list").connect("item_selected",self,"_on_select_language")
	get_node("language/list").select(SetData.language)
	#sound
	AudioServer.set_stream_global_volume_scale(SetData.sound.music/100)
	AudioServer.set_fx_global_volume_scale(SetData.sound.effect/100)
	#gui
	Function.msg_group("gui","set_opacity",float(SetData.gui.op)/100)
	set_bar()
	pass
func _on_select_language(index):
	language_id=index
func _on_music(val):
	get_node("music/text").set_text(str(int(val)))
func _on_effect(val):
	get_node("effect/text").set_text(str(int(val)))
func _on_gui(val):
	get_node("gui/text").set_text(str(int(val)))
var bar=0
func _on_bar(be):
	if(be):
		bar=1
	else:
		bar=0
func _on_sure():
	SetData.language=language_id
	SetData.sound.music=get_node("music/bar").get_val()
	SetData.sound.effect=get_node("effect/bar").get_val()
	SetData.gui.op=get_node("gui/bar").get_val()
	SetData.gui.bar=bar
	Function.msg_group("gui","set_opacity",float(SetData.gui.op)/100)
	AudioServer.set_stream_global_volume_scale(SetData.sound.music/100)
	AudioServer.set_fx_global_volume_scale(SetData.sound.effect/100)
	TranslationServer.set_locale(Config.GetConfig("LanguageArr")[SetData.language])
	Function.SetSaveData("set.save",SetData)
func _on_return():
	hide()
	set_bar()
	show_pgup()
func show_pgup():
	get_parent().get_node("set").show()
	get_parent().get_node("save").show()
	get_parent().get_node("return").show()
	get_parent().get_node("exit").show()
func set_bar():
	get_node("music/bar").set_val(SetData.sound.music)
	get_node("effect/bar").set_val(SetData.sound.effect)
	get_node("gui/bar").set_val(SetData.gui.op)
	get_node("language/list").select(SetData.language)
	get_node("bar/check").set_pressed(SetData.gui.bar)
	bar=SetData.gui.bar