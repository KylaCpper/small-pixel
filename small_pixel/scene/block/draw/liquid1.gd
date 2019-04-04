extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _draw():
	var vecs=[Vector2(0,0),Vector2(64,0),Vector2(64,64),Vector2(0,32)]
	var vecs1=[Vector2(0,0),Vector2(0,0),Vector2(0,64),Vector2(0,0)]
	var colors=[Color(100),Color(100),Color(1),Color(1)]
	draw_colored_polygon(vecs,Color(50),vecs,load("res://assets/img/block/stone.png"))
	#draw_texture_rect(load("res://assets/img/block/dirt.png"),Rect2(Vector2(32,64),Vector2(32,64)),false)
	pass