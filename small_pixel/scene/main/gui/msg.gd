extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="cmd"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("edit").connect("text_entered",self,"_on_enter")
	get_node("text").set_scroll_follow (true)
	set_process_input(true)
	pass
var cmd=0
var enter=0
func _input(event):
	var pressed=null
	var pos=0
	if(event.is_action_pressed("enter")):
		pressed=">"
		pos=1
	if(event.is_action_pressed("code")):
		pressed=">"
		pos=2
	if(pressed):
		if(cmd):return
		if(pos==1):enter=1
		cmd=1
		Overall.cmd=cmd
		Function.msg_group("player","_on_cmd",cmd)
		get_node("edit").set_text(pressed)
		get_node("edit").grab_focus() 
		get_node("edit").set_cursor_pos(pos)
		get_node("anm").stop()
		set_opacity(1)
		show()
		
func _on_enter(text):
	if(enter):
		enter=0
		return
	get_node("edit").release_focus()
	get_node("edit").clear()
	get_node("anm").play("cmd")
	Overall.cmd=0
	cmd=0
	Function.msg_group("player","_on_cmd",cmd)
	text=text.right(1)
	if(!text||text=="/"):return
	if(text.left(1)=="/"):
		text=text.right(1)
		var arr=text.split(" ")
		var code=arr[0]
		if(code=="get"):
			if(arr.size()<2):return
			Function.msg_group("bar","pull_item",arr[1])
		elif(code=="set_pos"):
			if arr.size()<2:return
			var vec=arr[1].split(",")
			if vec.size()<2:return
			add_msg("set pos "+str(vec[0])+","+str(vec[1]))
			get_tree().get_nodes_in_group("player")[0].set_pos(Vector2(int(vec[0]),int(vec[1])))
		elif(code=="get_pos"):
			var pos = get_tree().get_nodes_in_group("player")[0].get_pos()
			add_msg("current pos "+str(int(pos.x))+","+str(int(pos.y)))
			
#		elif(code=="save"):
#			var scene = PackedScene.new()
#			var result = scene.pack(get_tree().get_current_scene())
#			if result == OK:
#				ResourceSaver.save("res://save.tscn", scene)
		else:
			add_msg("not find cmd "+code,1)
	else:
		add_msg(text)
func add_msg(text,err=0):
	show()
	set_opacity(1)
	get_node("anm").play("cmd")
	var color=""
	if(err==1):
		color="[color=red]error: [/color]"
	if(err==2):
		color="[color=yellow]warning: [/color]"
	get_node("text").append_bbcode(color+text+"\n")