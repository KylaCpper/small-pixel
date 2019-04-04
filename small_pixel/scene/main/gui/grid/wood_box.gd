extends "../Grid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group1="wood_box"
func _ready():
	add_to_group(group1)
	grid=28
	init()
	update()
func _show():
	that.open()
func _hide():
	that.close()