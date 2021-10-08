extends "../Compound.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group2="workbench"
func _ready():
	add_to_group(group2)
	grid=9
	init()
