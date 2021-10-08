extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var mode=[
	"build",
	"build_bg",
	"hurt mode"
]
var index=0
func _ready():
	# Called every time the node is added to the scene.
	get_node("mode").connect("pressed",self,"_on_pressed")
	get_node("select/mode0").connect("pressed",self,"_on_change_mode",[0])
	get_node("select/mode1").connect("pressed",self,"_on_change_mode",[1])
	get_node("select/mode2").connect("pressed",self,"_on_change_mode",[2])
	set_process_input(true)
	_on_change_mode(0)
	pass
var pos=Vector2(0,0)
func _input(event):
	if(Overall.cmd):return
	if(event.type==InputEvent.MOUSE_MOTION||event.type==InputEvent.MOUSE_BUTTON ):
		pos=event.pos
	if(event.is_action_pressed("alt")):
		get_node("select").set_pos(pos)
		get_node("select").show()
	if(event.is_action_released("alt")):
		get_node("select").hide()
		pass
	if(event.is_action_released("c")):
		_on_pressed()
func _on_change_mode(index):
	self.index=index
	get_node("mode").set_text(mode[index])
	Overall.mode=index
	get_tree().call_group(0,"player","_on_change_mode")
	get_node("select").hide()
func _on_pressed():
	index+=1
	if(index>=mode.size()):index=0
	get_node("mode").set_text(mode[index])
	Overall.mode=index
	get_tree().call_group(0,"player","_on_change_mode")
	pass