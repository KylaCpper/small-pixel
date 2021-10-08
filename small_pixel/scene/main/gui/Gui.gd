extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	pass
func display():
	get_tree().call_group(0,"bag","display",self,1)
func _on_show():
	_show()
	show()
func _on_hide():
	_hide()
	hide()
func _show():
	pass
func _hide():
	pass