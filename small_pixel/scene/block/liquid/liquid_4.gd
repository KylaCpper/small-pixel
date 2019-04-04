extends "Liquid_flow.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	pass
func extend_flow():
	ray_exam("left")
	ray_exam("right")
func init_():
	get_node("area").set_gravity(48*speed)