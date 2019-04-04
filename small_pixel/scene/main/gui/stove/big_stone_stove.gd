extends "../Stove.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var group2="big_stone_stove"
func _ready():
	add_to_group(group2)
	grid=4
	out_grid=2
	init()
	update()
