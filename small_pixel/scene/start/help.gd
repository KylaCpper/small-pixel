extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("close").connect("pressed",self,"_on_close_press")
	get_node("qq").connect("pressed",self,"_on_qq_press")
	get_node("qq_qun").connect("pressed",self,"_on_qq_qun_press")
	pass
func _on_close_press():
	get_tree().call_group(0,"home","close_other_window","help")
	pass
func _on_qq_press():
	OS.shell_open("https://jq.qq.com/?_wv=1027&k=5uCRFZJ")
func _on_qq_qun_press():
	OS.shell_open("https://jq.qq.com/?_wv=1027&k=5uCRFZJ")