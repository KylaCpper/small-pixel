extends RayCast2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var group="ray_gui"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)

	set_fixed_process(true)
	pass
var pos=Vector2(0,0)
var pos_be=null
var obj_gui=null
func _input(event):
	if(OverallGui.show):
		if(event.is_action_pressed("mouse_left")):
			set_pos(get_global_mouse_pos())
			force_raycast_update()
			var obj=get_collider()
			if(is_colliding()):
				if(obj.get_parent().is_visible()):
					return
			if(OverallGui.item_sprite!=null):
				Function.msg_group("sound","effects","other","throw",get_pos())
			OverallGui.throw_hand_item()
			
func _fixed_process(delta):
		if(OverallGui.show):
			if(Input.is_action_pressed("mouse_left")):
				var global_mouse_pos=get_global_mouse_pos()
				set_pos(global_mouse_pos)
				force_raycast_update()
				var obj=get_collider()
				if(is_colliding()):
					if(obj.get_parent().is_visible()):
						if(obj.get_name()=="head"):
							obj_gui=obj.get_parent()
							if(pos_be!=null):
								obj_gui.set_pos(global_mouse_pos+pos_be)
							pos=obj_gui.get_pos()-global_mouse_pos
							pos_be=pos
							return
				else:
					pos_be=null
				if(obj_gui):
					var pos_=global_mouse_pos+pos
					obj_gui.set_pos(pos_)
			else:
				obj_gui=null
				pos_be=null