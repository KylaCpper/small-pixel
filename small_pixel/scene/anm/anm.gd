extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var health =10
var time_ =0.5
var hurt=0
var speed=50
var bg=0
var name="pig"
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("area").connect("area_enter",self,"_on_hurt")
	get_node("time").connect("timeout",self,"_on_timeout")
	get_node("time").set_wait_time(time_)
	set_fixed_process(true)
var vector=Vector2(0,0)
var dire=[-1,1]
var time=0
var move_time=0
var dire_index=0
var hurt_time=7
func direction(dire):
	if dire==-1:
		get_node("head").set_flip_h(false)
		get_node("body").set_flip_h(false)
		get_node("head").set_pos(Vector2(-6.5,-8))
		get_node("body").set_pos(Vector2(15,-8))
	else:
		get_node("head").set_flip_h(true)
		get_node("body").set_flip_h(true)
		get_node("head").set_pos(Vector2(24.5,-8))
		get_node("body").set_pos(Vector2(3,-8))
func _fixed_process(delta):

	vector+=Vector2(0,speed)*delta
	vector = move_and_slide(vector, Vector2(0,-1), 20)
	time+=delta
	var x=0
	if hurt==1:
		hurt_time=0
	hurt_time+=delta
	if hurt_time<7:
		x=speed*dire_index
		direction(dire_index)
	else:
		if time>2:
			time=0
			if move_time<2:
				move_time+=delta
				var dire_=randi()%2
				x=speed*dire[dire_]
				direction(dire[dire_])
				vector.x = lerp(vector.x, x, 0.8)
			else:
				move_time=0
	if x:
		move_ani()
func _on_free():
	for i in range(randi()%4+1):
		Function.msg_group("plane","drop_item",{"name":"pig_meat","num":1,"health":0},get_pos())
	queue_free()
	pass
func _on_timeout():
	hurt=0
func _on_hurt(obj):
	if !hurt:
		var sub=1
		if Overall.hand.name:
			if Config.items_type[Overall.hand.name]=="tool":
				sub=Config.tools[Overall.hand.name].atk
				Overall.hand.health-=1
				if Overall.hand.health<=0:
					Function.clear_item(Overall.hand)
				Function.msg_group("bar","update")
		health-=sub
		if health<=0:
			get_node("sound").play("pig_died")
			_on_free()
			
		hurt=1
		get_node("time").start()
		if Function.player.get_pos().x<get_pos().x:
			move(Vector2(10,-20))
			dire_index=1
		else:
			move(Vector2(-10,-20))
			dire_index=-1
		hurt_ani()
func hurt_ani():
	get_node("sound").play("pig_hurt")
	get_node("ani").play("pig_hurt")
func move_ani():
	if !get_node("ani").is_playing():
		get_node("ani").play("pig_walk")
func _on_total_save():
	var pos=get_pos()
	var save={
		"name":"pig",
		"pos":{"x":pos.x,"y":pos.y},
		"bg":0,
	}
	return save
func _on_load(data):
	pass