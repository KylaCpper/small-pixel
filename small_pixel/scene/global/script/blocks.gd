extends Node
var data={
#default
	"default":{"handness":0.5,"script":"block"},
	"water":{},
	"unknown_block":{"handness":999,"script":"block"},
#铲子
	"grass_dirt":	{"handness":0.7,"script":"grass_dirt",	"tools":["shovel"],	"lv":0,"sound":"grass","friction":1,"bounce":0.5},
	"dirt":			{"handness":0.5,"script":"dirt",	"tools":["shovel"],	"lv":0,"sound":"dirt","friction":0.7,"bounce":0.4},
	"dirt_plow":	{"handness":0.5,"script":"dirt_plow","tools":["shovel"],"lv":0,"sound":"dirt","friction":0.9,"bounce":0.1},
	"sand":			{"handness":0.5,"script":"sand",	"tools":["shovel"],	"lv":0,"sound":"sand","friction":0.8,"bounce":0.1},
	
#镐子
	"coal_ore":			{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":0},
	"copper_ore":		{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":1},
	"tin_ore":			{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":1},
	"zinc_ore":			{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":1},
	"silver_ore":		{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":2},
	"iron_ore":			{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":2},
	"gold_ore":			{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":3},
	"diamond_ore":		{"handness":5.0,"script":"block",	"tools":["pickaxe"],	"lv":3},
	
	"stone":		{"handness":4.0,"script":"stone",	"tools":["pickaxe"],	"lv":0,"friction":0.7,"bounce":0.5},
	"crushed_stone":{"handness":4.5,"script":"block",	"tools":["pickaxe"],	"lv":0,"friction":0.7,"bounce":0.5},
	"stone_stove":	{"handness":4.5,"script":"stone_stove",	"tools":["pickaxe"],"lv":0},
	"relic_stone":	{"handness":5.0,"script":"block",	"tools":["pickaxe"],	"lv":0,"friction":0.7,"bounce":0.5},
#斧子
	"wood":			{"handness":1.5,"script":"block",	"tools":["axe"],		"lv":0,"sound":"wood"},
	"wood_board":	{"handness":1.0,"script":"block",	"tools":["axe"],		"lv":0,"sound":"wood"},
	"workbench":	{"handness":2.0,"script":"workbench","tools":["axe"],		"lv":0,"sound":"wood"},
	"wood_box":		{"handness":2.0,"script":"wood_box","tools":["axe"],		"lv":0,"sound":"wood"},
	
#剪刀,剑
	"leaf":			{"handness":0.4,"script":"leaf",	"tools":["sword","scissors"],	"lv":0,"sound":"leaf"},
	"leaf_dead":	{"handness":0.4,"script":"block",	"tools":["sword","scissors"],	"lv":0,"sound":"leaf"},
#大型设备
	"big_stone_stove":{"handness":4.0,"script":"big_stone_stove",	"tools":["pickaxe"],"lv":0},
	"high_stone_stove":{"handness":4.0,"script":"high_stone_stove",	"tools":["pickaxe"],"lv":0},
	"big_stone_stove_wall":{"handness":4.0,"script":"block",	"tools":["pickaxe"],	"lv":0},
#扳手
	"wood_gear":	{"handness":4.0,"script":"gear",	"tools":["pickaxe","wrench"],"lv":0,"sound":"wood"},
	"button":		{"handness":0.5,"script":"button",	"tools":[],"lv":0,"sound":"wood"},
#other
	"pull_rod":		{"handness":0.5,"script":"pull_rod"},
	"door":			{"handness":1.5,"script":"door","tools":["axe"],"sound":"wood"},
	"torch":		{"handness":0.1,"script":"light"},
	"door":		{"handness":0.5,"script":"door","tools":["axe"],"sound":"wood"},
	"door0":	{"handness":0.5,"script":"door0","tools":["axe"],"sound":"wood"},
	"pressure_board":{"handness":0.5,"script":"pressure_board","tools":["axe"],"sound":"wood"},
#plant
	"wheat_seed":{"handness":0.1,"script":"wheat_seed","sound":"grass"},
	"paddy_seed":{"handness":0.1,"script":"paddy_seed","sound":"grass"},
	"oak_seed":{"handness":0.1,"script":"tree","sound":"grass"},
	"herb":{"handness":0.1,"script":"herb","sound":"grass"},
##other
	"ladder":{"handness":0.5,"script":"ladder","tools":["axe"],"sound":"wood"},
	"wood_vat":{"handness":0.5,"script":"wood_vat","tools":["axe"],"sound":"wood"},
	"funnel":{"handness":2.0,"script":"funnel","tools":["pickaxe"]},
}
