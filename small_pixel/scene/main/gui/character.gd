extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="player_property"
var player=Overall.player
func _ready():
	add_to_group(group)
	update()
	pass
func update(key=null):
	if(key==null):
		all_update()
	else:
		for i in range(player[key]["max"]/2):
			if((i+1)*2<=player[key].val):
				get_node(key+'/arrow'+str(i)).set_value(2)
			elif((i+1)*2-1==player[key].val):
				get_node(key+'/arrow'+str(i)).set_value(1)
			else:
				get_node(key+'/arrow'+str(i)).set_value(0)
		if(key=="health"||key=="food"||key=="water"):
			get_node(key+"_anm").play(key)
func all_update():
	update("health")
	update("food")
	update("water")
	update("animal")
	update("plant")
	update("oxygen")