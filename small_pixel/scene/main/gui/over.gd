extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="over"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("sure").connect("pressed",self,"_on_sure")
	get_node("exit").connect("pressed",self,"_on_exit")
	pass
func over(pos):
	if(OverallGui.show):
		Function.msg_group("gui","hide")
		OverallGui.show=0
	show()
	Function.msg_group("bar","drop_all",pos)
	Function.msg_group("bag","drop_all",pos)
func _on_sure():
	hide()
	OverallGui.show=0
	Function.msg_group("player","init_player")
	Function.msg_group("player_status","_on_free")

	
func _on_exit():
	hide()
	Global.GoTo_Scene("res://scene/start/start.tscn")