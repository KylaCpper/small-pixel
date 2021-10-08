extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var name="kylaCpp"
export var group="player"
const GRAVITY = 500.0 # Pixels/second
# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 210
const JUMP_MAX = 200
const JUMP_MAX_AIRBORNE_TIME = 0.2
const MOVE_SPEED=80#80
const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100#100
var jumping = false

var prev_jump_pressed = false
var direction="left"
var crack_texture=[]
var animal_time=0
var plant_time=0
var food_time=0
var water_time=0
var reply_time=0
var fall_time=0
var ladder=0
onready var player=Overall.player
onready var ray_=get_node("ray_")
var pos
var load_plane=0
func _ready():
	add_to_group(group)
	Function.player=self
	if(Overall.Load):
		_on_load(Overall.SaveData.player_info)
	else:
		pos=get_pos()
		set_pos(Vector2(0,-200))
		"""
		for i in range(50):
			set_pos(Vector2(pos_.x,pos_.y+(32*i)))
			ray_.force_raycast_update()
			if(ray_.is_colliding()):
				pos=Vector2(pos_.x,pos_.y+(32*(i-4)))
				break
		"""
	Function.init_item(hand)
	crack_texture.append(preload("res://assets/img/crack/crack1.png"))
	crack_texture.append(preload("res://assets/img/crack/crack2.png"))
	crack_texture.append(preload("res://assets/img/crack/crack3.png"))
	crack_texture.append(preload("res://assets/img/crack/crack4.png"))
	crack_texture.append(preload("res://assets/img/crack/crack5.png"))
	crack_texture.append(preload("res://assets/img/crack/crack6.png"))
	get_node("time").connect("timeout",self,"_on_eat")
	set_fixed_process(true)
	set_process_input(true)
	ani_move("left")
	pass
func get_obj():
		Function.msg_group("func_item","give_obj",self)
var left_press=0
var right_press=0
var hand={}
func _on_bar_current(item):
	hand=item
	if(!item.name):
		get_node("item_left").set_texture(null)
		get_node("item_right").set_texture(null)
	else:
		if(Config.items_type[item.name]=="tool"):
			get_node("item_left").set_scale(Vector2(0.75,0.75))
			get_node("item_right").set_scale(Vector2(0.75,0.75))
		else:
			get_node("item_left").set_scale(Vector2(0.5,0.5))
			get_node("item_right").set_scale(Vector2(0.5,0.5))
		get_node("item_left").set_texture(Overall.textures[item.name])
		get_node("item_right").set_texture(Overall.textures[item.name])
var gui=0
var cmd=0
func _on_cmd(be):
	cmd=be
func _on_gui(be):
	gui=be
var speed=1
var ani_name="place"
var ray=null
func _on_change_mode():
	if(Overall.mode==Config.mode.hurt_mode):
		_on_block_enter()
		ray=null
		speed=0.5
		ani_name="hurt"
	else:
		_on_block_enter()
		if(Overall.mode==Config.mode.build):ray="ray_block"
		if(Overall.mode==Config.mode.build_bg):ray="ray_bg"
		speed=1
		ani_name="place"
var use=0
func _input(event):
	if(gui||eat||cmd||use):return
	if(event.is_action_pressed("q")):
		if(hand.num>0):
			Function.msg_group("sound","effects","other","throw",get_pos())
		OverallGui.throw_item(hand)
		
	if(event.type==InputEvent.MOUSE_MOTION||event.type==InputEvent.MOUSE_BUTTON ):
		global_mouse_pos=get_global_mouse_pos()
		local_mouse_pos=event.pos

	pass
func _on_eat():
	if(hand.num==null):
		return
	var food=Config.foods[hand.name]
	#status add
	if("add" in food):
		for data in food.add:
			Function.msg_group("status","add_status",data)
	#status remove
	if("remove" in food):
		for data in food.remove:
			Function.msg_group("status","remove",data)
	#time
	#status_time
	#food
	#speed
	#plant
	var add=0
	if(food.plant):
		if(player.plant.val>=7):
			add=int(food.plant/2)
		else:
			add=food.plant
		add_limit("plant",add)
	if(food.animal):
		if(player.animal.val>=7):
			add=int(food.animal/2)
		else:
			add=food.animal
		add_limit("animal",add)

	add_limit("water",food.water)
	add_limit("food",food.food)
	
	if(Overall.status_list.hungry):
		if(player.food.val>=3):
			Function.msg_group("status","remove_status","hungry")
	if(Overall.status_list.thirst):
		if(player.water.val>=3):
			Function.msg_group("status","remove_status","thirst")
	hand.num-=1
	Function.msg_group("bar","update")
	Function.msg_group("sound","eat_stop")
func add_limit(key,num):
	if(!num):return
	player[key].val+=num
	if(player[key].val>player[key]["max"]):
		player[key].val=player[key]["max"]
	Function.msg_group("player_property","update",key)
var helium=10
var helium_=0
func ray_liquid(delta):
	#head
	var into=0
	var _ray=get_node("_ray")
	_ray.force_raycast_update()
	if(_ray.is_colliding()):
		var obj=_ray.get_collider()
		if(!obj.is_queued_for_deletion()):
			obj=obj.get_parent()
			if(Config.items_type[obj.name]=="liquid"):
				helium-=delta
				player.oxygen.val=int(helium)
				into=1
				Function.msg_group("player_property","update","oxygen")
				if(helium<=0):
					helium_+=delta
					if(helium_>=1):
						helium_=0
						player.health.val-=1
						fall_health_sound()
						Function.msg_group("player_property","update","health")
	if(!into&&helium<=10):
		helium+=delta*5
		player.oxygen.val=int(helium)
		Function.msg_group("player_property","update","oxygen")
	#body
	var ray=get_node("ray")
	ray.force_raycast_update()
	if(ray.is_colliding()):
		var obj=ray.get_collider()
		if(!obj.is_queued_for_deletion()):
			return obj.get_parent()
		else:
			return null
	else:
		return null
func ray_ladder():
	ladder=0
	var _ray=get_node("ray__")
	_ray.force_raycast_update()
	if(_ray.is_colliding()):
		var obj=_ray.get_collider()
		if(!obj.is_queued_for_deletion()):
			if(obj.name=="ladder"):
				ladder=1
				
var over=0
var status_pro=1
var eat=0
var eat_time=0
var water=0
var water_dire="left"
var water_pro=1
var place_time=0.1
var water_jump=1
var first=0
var ladder_time=0
var ladder_m=0
func _fixed_process(delta):
	if load_plane:return
	eat=0
	if(over):return
	var fall_delta=delta
	var obj = ray_liquid(delta)
	ray_ladder()
	if(obj!=null):
		if(Config.items_type[obj.name]=="liquid"):
			water=1
			water_dire=obj.direction
			var water_speed=obj.speed*30
			water_jump=0.5/obj.speed
			water_pro=0.5/obj.speed
			if(water_dire=="left"):
				move(Vector2(-water_speed*delta,0))
			elif(water_dire=="right"):
				move(Vector2(water_speed*delta,0))
			elif(water_dire=="down"):
				water_jump=0.3/obj.speed/2

	else:
		water=0
		water_pro=1
	

	if(gui):
		ani_hurt(ani_name,speed,false)
	elif(cmd):
		pass
	elif(use):
		pass
	else:
		left_press=Input.is_action_pressed("mouse_left")
		right_press=Input.is_action_pressed("mouse_right")
		if(left_press||right_press):
			var active=""
			if(right_press):
				if(hand.name):
					var hand_name=Config.items_type[hand.name]
					if(hand_name=="item"||hand_name=="func_item"||hand_name=="func_items"):
						Function.msg_group("func_item",hand.name)
					elif(hand_name=="food"&&Overall.player.food.val<11):
						var food_be=Config.foods[hand.name]
						var food_time=3
						if("time" in food_be):
							food_time=food_be.time
						if(eat_time>=food_time):
							_on_eat()
							eat_time=0
						else:
							active="eat_"
							eat_time+=delta
							eat=1
						
					else:
						place_time-=delta
						if(place_time<=0):
							place()
			else:
				eat_time=0
				Function.msg_group("sound","eat_stop")
			if(left_press):
				damage(delta)
			ani_hurt(ani_name,speed,true,active)
			fall_delta*=2
		else:
			eat_time=0
			Function.msg_group("sound","eat_stop")
			block_damage_time=0
			block_damage_ani=0
			if(block!=null):
				if(!Function.is_queue_free(block)):
					Overall.select.get_node("crack").set_texture(crack_texture[0])
			ani_hurt(ani_name,speed,false)
	var offset_pro=status_pro*water_pro
	var force = Vector2(0, GRAVITY)
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var walk_up=Input.is_action_pressed("move_up")
	var walk_down=Input.is_action_pressed("move_down")
	var jump = Input.is_action_pressed("jump")
	if(gui||cmd):
		walk_left=false
		walk_right=false
		jump=false
	else:
		_on_block_enter(1)
	var stop = true
	
	if (walk_left):
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			ani_move("left")
			force.x = -MOVE_SPEED*offset_pro
			stop = false
			fall_delta*=2
	elif (walk_right):
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			ani_move("right")
			force.x = MOVE_SPEED*offset_pro
			stop = false
			fall_delta*=2
	else:
		ani_move()

	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		velocity.x = vlen*vsign
	# Integrate forces to velocity
	velocity.x = force.x*delta*100
	if(!ladder):
		velocity.y +=force.y*delta*water_pro
	else:
		velocity.y =MOVE_SPEED*offset_pro
		if (walk_up):
			fall_delta*=2
			velocity.y -=MOVE_SPEED*offset_pro*2
			ladder_time-=delta*2
		if(walk_down||jump):
			fall_delta*=2
			velocity.y +=MOVE_SPEED*offset_pro
			ladder_time+=delta
		ladder_time+=delta
		if(ladder_time>=0.6||ladder_time<=-0.6):
			ladder_time=0
			var obj=Function.ray(get_node("ray_"),get_node("ray_").get_pos())
			if(obj):
				if(obj.name=="ladder"):
					if(ladder_m):
						ladder_m=0
					else:
						ladder_m=1
					Function.msg_group("sound","effects","other","ladder"+str(ladder_m),get_pos())
	# Integrate velocity into motion and move
	var motion = velocity*delta
	# Move and consume motion
	motion = move(motion)
	var floor_velocity = Vector2()
	if (is_colliding()):
		# You can check which tile was collision against with this
		# Ran against something, is it the floor? Get normal
		var n = get_collision_normal()
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) <20):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			if(on_air_time>1):
				if(velocity.y>=500):
					if(first):
						var fall=int((velocity.y-500)/100)
						if(fall):
							if(player.health.val>0):
								player.health.val-=fall
								fall_health_sound()
								Function.msg_group("player_property","update","health")
						_on_move_sound()
					else:
						first=1
				elif(velocity.y>=200):
					_on_move_sound()
				
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		else:
			ray_.force_raycast_update()
			if(ray_.is_colliding()):
				on_air_time = 0
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Since this formula will always slide the character around, 
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)

	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	if(water&&jump):
		velocity.y = -JUMP_SPEED*offset_pro
	elif (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not jumping):
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		_on_move_sound()
		velocity.y = -JUMP_SPEED
		jumping = false
		fall_delta*=3
	animal_time+=fall_delta
	plant_time+=fall_delta
	food_time+=fall_delta*food_pro
	water_time+=fall_delta
	fall_time+=delta
	reply_time+=delta
	_on_check_fall()
	on_air_time += delta
	#prev_jump_pressed = jump
var food_pro=1
func _on_check_fall():
	if(water_time>=3):
		first=1
	var fall_health=0
	var reply_health=0
	if(player.animal.val>0):
		if(animal_time >= player.animal.time):
			animal_time=0
			player.animal.val-=1
			Function.msg_group("player_property","update","animal")
			if(player.plant.val>0):
				Function.msg_group("status","remove_status","malnutrition")
	else:
		Function.msg_group("status","add_status","malnutrition")
		animal_time=0
	if(player.plant.val>0):
		if(plant_time >= player.plant.time):
			plant_time=0
			player.plant.val-=1
			Function.msg_group("player_property","update","plant")
	else:
		Function.msg_group("status","add_status","malnutrition")
		plant_time=0
	if(player.food.val>0):
		if(food_time >= player.food.time):
			food_time=0
			player.food.val-=1
			Function.msg_group("player_property","update","food")
		if(player.food.val==player.food["max"]):
			reply_health+=0.5
	else:
		fall_health=1
	if(player.water.val>0):
		if(water_time >= player.water.time):
			water_time=0
			player.water.val-=1
			Function.msg_group("player_property","update","water")
		if(player.water.val==player.water["max"]):
			reply_health+=0.5
		
	else:
		fall_health=1
	if(reply_health==1):
		if(reply_time >= 9):
			reply_time=0
			if(player.health.val>0&&player.health.val<player.health["max"]):
				player.health.val+=1
				food_time+=10
				plant_time+=10
				animal_time+=10
				water_time+=10
				Function.msg_group("player_property","update","health")
	if(fall_health):
		if(player.health.val>0):
			if(fall_time >= 3):
				fall_time=0
				player.health.val-=1
				fall_health_sound()
				Function.msg_group("player_property","update","health")
	if(player.health.val<=0):
		Function.msg_group("over","over",get_pos())
		over=1
		first=0
	if(player.food.val<3):
		Function.msg_group("status","add_status","hungry")
	if(player.water.val<3):
		Function.msg_group("status","add_status","thirst")
func init_player():
	set_pos(pos)
	over=0
	health=0
	player.health.val=player.health["max"]
	player.plant.val=player.plant["max"]
	player.animal.val=player.animal["max"]
	player.food.val=player.food["max"]
	player.water.val=player.water["max"]
	Function.msg_group("player_property","all_update")
func change_offset(arg,pro):
	self[arg]=pro
func _on_move_sound(first=false):
	if(water):
		if(!first):
			Function.msg_group("sound","move","swim")
		return
	var obj=Function.ray(ray_,ray_.get_pos())
	if(obj!=null):
		if(Config.items_type[obj.name]=="liquid"):
			if(!first):
				Function.msg_group("sound","move","swim")
		if("sound" in Config.blocks[obj.name]):
			Function.msg_group("sound","move",Config.blocks[obj.name].sound)
		else:
			Function.msg_group("sound","move","stone")
func _on_place_sound(name,pos):
	if("sound" in Config.blocks[name]):
		Function.msg_group("sound","effects","place",Config.blocks[name].sound,pos)
	else:
		Function.msg_group("sound","effects","place","stone",pos)
func _on_dig_sound(name,pos):
	if("sound" in Config.blocks[name]):
		Function.msg_group("sound","effects","dig",Config.blocks[name].sound,pos)
	else:
		Function.msg_group("sound","effects","dig","stone",pos)
func eat_sound():
	Function.msg_group("sound","eat")
var health=0
func change_health():
	health=0
func fall_health_sound(x=0):
	health=1
	move(Vector2(x,-10))
	get_node("place").play("health")
	Function.msg_group("sound","effects","other","health",get_pos())
func ani_move(direction=null):
	var node=get_node("move")
	if(!direction):
		node.stop(true)
		return
	if(self.direction!=direction):
		self.direction=direction
		node.play(direction)
		if(use&&!health):
			var pos=get_node("place").get_pos()
			var speed=get_node("place").get_speed()
			get_node("place").play("use_"+direction,-1,speed)
			get_node("place").seek(pos)
	elif(!node.is_playing()):
		self.direction=direction
		node.play(direction)
		
func ani_hurt(name,speed=1,start=false,active=""):
	if(health):return
	if active=="eat_":
		name="place"
	var node=get_node(name)
	if(start):
		node.set_speed(speed)
		if(!node.is_playing()):
			node.play(active+direction)
		else:
			var be=node.get_current_animation()
			if(active+direction!=be):
				node.play(active+direction)
	else:
		node.stop()
		use=0
		node.play("state")
func _on_hurt(be):
	get_node("left_arm/hurt").set_layer_mask_bit(4,be)
	get_node("left_arm/hurt").set_collision_mask_bit(4,be)
	get_node("right_arm/hurt").set_layer_mask_bit(4,be)
	get_node("right_arm/hurt").set_collision_mask_bit(4,be)
var global_mouse_pos=Vector2(0,0)
var local_mouse_pos=Vector2(0,0)
func _on_use(be):
	use=be
func place():
	if(Function.hand_distance(get_pos(),0)):
		if(hand.name&&hand.num):
			var item_type=Config.items_type[hand.name]
			if(item_type=="block"):
				if(Overall.mode==Config.mode.build):
					get_tree().call_group(0,"ray_block","place",global_mouse_pos,hand)
				if(Overall.mode==Config.mode.build_bg):
					get_tree().call_group(0,"ray_bg","place",global_mouse_pos,hand)
			elif(item_type=="liquid"):
				if(Overall.mode==Config.mode.build):
					get_tree().call_group(0,"ray_block","place",global_mouse_pos,hand,0,"place_liquid")
			elif(item_type=="gear"):
				if(Overall.mode==Config.mode.build):
					get_tree().call_group(0,"ray_block","place",global_mouse_pos,hand,0,"place_gear")
				if(Overall.mode==Config.mode.build_bg):
					get_tree().call_group(0,"ray_bg","place",global_mouse_pos,hand,0,"place_gear")
			elif(item_type=="switch"||item_type=="seed"||item_type=="light"):
				if(Overall.mode==Config.mode.build):
					get_tree().call_group(0,"ray_block","place",global_mouse_pos,hand)
		else:
			Function.clear_item(hand)
			get_tree().call_group(0,"bar","update")
			#get_tree().call_group(0,"plane","place","grass_dirt",place_pos)
var block_damage_ani=0
var arm_damage_time=0
func damage(delta):
	Input.warp_mouse_pos(local_mouse_pos)
	if(block!=null):
		if(Function.is_queue_free(block)):return
		if(Function.hand_distance(get_pos(),1)):
			var tool_ture=0
			var tool_type=""
			var delta_=delta
			var block_type=Config.items_type[block.name]
			if(block_type=="block"||block_type=="gear"||block_type=="switch"||block_type=="light"||block_type=="seed"):
				if(hand.name in Config.tools):
					tool_type=Config.tools[hand.name].type
				#查询工具是否合适  以及加成使用工具挖矿速度
				var block_name="def"
				if(block.name in Config.blocks):
					 block_name=block.name
				if("tools" in Config.blocks[block_name]):
					for _tool in Config.blocks[block_name]["tools"]:
						if(tool_type==_tool):
							var lv =0
							if("lv" in Config.blocks[block_name]):lv=Config.blocks[block_name].lv
							if(lv<=Config.tools[hand.name].lv):
								delta_=delta_*Config.tools[hand.name].addition
								tool_ture=1
							break
						pass
				
				var offset_pro=status_pro*water_pro
				delta_*=offset_pro
				if(block_damage_time==0):arm_damage_time=0
				block_damage_time+=delta_
				arm_damage_time+=delta
				if(block_damage_ani-arm_damage_time<=0):
					_on_dig_sound(block_name,block.get_pos())
					block_damage_ani+=0.3
				var crack=block_damage_time/(Config.blocks[block_name].handness/5)
				
				Overall.select.get_node("crack").set_texture(crack_texture[int(crack)])
				if(block_damage_time>=Config.blocks[block_name].handness):
					if(tool_ture):
						hand.health-=1
						if(hand.health<=0):
							Function.clear_item(hand)
					get_tree().call_group(0,"bar","update")
					if(!tool_type):tool_type=""
					get_tree().call_group(0,"plane","damage",block,tool_ture,tool_type)
					block=null
					block_damage_time=0
					block_damage_ani=0
					Overall.select.hide()

var block=null
var block_damage_time=0

func _on_block_enter(mode=0):
	var select=Overall.select
	if(select==null):return
	if(ray==null):return
	var obj=Function.ray(get_parent().get_node(ray),get_global_mouse_pos())
	if(block!=null):
		var free=Function.is_queue_free(block)
		if (free||block.get_type()!="StaticBody2D"):
			block=obj
			return
		
		if(obj==null):
			select.hide()
			select.get_node("crack").set_texture(crack_texture[0])
			block=null
			block_damage_time=0
			block_damage_ani=0
			return
		if(block.get_name()==obj.get_name()):
			return
		select.hide()
		select.get_node("crack").set_texture(crack_texture[0])
	else:
		select.hide()
		select.get_node("crack").set_texture(crack_texture[0])
		if(obj==null):return
		
	block=obj
	block_damage_time=0
	block_damage_ani=0
	if(Function.hand_distance(get_pos(),1)):
		if(block!=null):
			var wr = weakref(block)
			if (wr.get_ref()):
				select.show()
				select.set_pos(block.get_pos())
func _on_save():
	var data={}
	data.init_pos={"x":pos.x,"y":pos.y}
	data.pos={"x":get_pos().x,"y":get_pos().y}
	return data
func _on_load(data):
	set_pos(Vector2(data.pos.x,data.pos.y))
	pos=Vector2(data.init_pos.x,data.init_pos.y)