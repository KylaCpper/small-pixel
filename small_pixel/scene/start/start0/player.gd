extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed=100
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	set_fixed_process(true)
	pass
var pos=Vector2(0,0)
func _fixed_process(delta):
#	if(get_parent().show):return
	var up=Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	var left=Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")

	var move_pos=Vector2(0,0)
	
	if(up):
		get_node("Sprite").set_rotd(-90)
		get_node("Sprite").set_flip_h(false)
		pos.x=0
		pos.y=-30
		move_pos.y-=speed
	if(down):
		get_node("Sprite").set_rotd(-90)
		get_node("Sprite").set_flip_h(true)
		pos.x=0
		pos.y=30
		move_pos.y+=speed
	if(left):
		get_node("Sprite").set_rotd(0)
		get_node("Sprite").set_flip_h(false)
		pos.x=-30
		pos.y=0
		move_pos.x-=speed
	if(right):
		get_node("Sprite").set_rotd(0)
		get_node("Sprite").set_flip_h(true)
		pos.x=30
		pos.y=0
		move_pos.x+=speed
	

	move(move_pos*delta)
func _input(event):
	if(event.is_action_pressed("event_")):
		if(get_parent().show):
			get_parent()._on_continue()
			return
		var ray=get_node("ray")
		ray.set_pos(pos)
		ray.force_raycast_update()
		if(ray.is_colliding()):
			var obj=ray.get_collider()
			get_parent()._on_event(obj.get_name())
		pass