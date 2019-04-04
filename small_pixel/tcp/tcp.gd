extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# instance
# instance
var websocket

# handler to text messages
func _on_message(msg):
	print(msg)

# handler to some button on you scene
func _on_some_button_released():
	websocket.send("msg send")

func _disconnect():
	websocket.disconnect() 
# entry point
func _ready():
	get_node("Button").connect("button_down",self,"_on_some_button_released")
	get_node("Button1").connect("button_down",self,"_disconnect")
	websocket = preload('./tcp_base.gd').new(self)
	websocket.start('127.0.0.1',6969)
	websocket.set_reciever(self,'_on_message')