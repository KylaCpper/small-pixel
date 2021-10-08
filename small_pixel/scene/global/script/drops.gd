extends Node
var data={
#default
	"default":		{"def":null},
	"unknown_block":	{"def":[{"name":"unknown_block","num":1}]},
#铲子
	"grass_dirt":	{"def":[{"name":"dirt","num":1,"random":100}]},
	"dirt":			{"def":[{"name":"dirt","num":1,"random":100}]},
	"dirt_plow":	{"def":[{"name":"dirt","num":1,"random":100}]},
	"sand":			{"def":[{"name":"sand","num":1}]},
#镐子
	"copper_ore":	{"def":null,"pickaxe":[{"name":"copper_ore","num":1}]},
	"tin_ore":		{"def":null,"pickaxe":[{"name":"tin_ore","num":1}]},
	"zinc_ore":		{"def":null,"pickaxe":[{"name":"zinc_ore","num":1}]},
	"iron_ore":		{"def":null,"pickaxe":[{"name":"iron_ore","num":1}]},
	"coal_ore":		{"def":null,"pickaxe":[{"name":"coal","num":3,"min":1}]},
	"diamond_ore":	{"def":null,"pickaxe":[{"name":"diamond","num":3,"min":1}]},
	"silver_ore":	{"def":null,"pickaxe":[{"name":"silver_ore","num":1}]},
	"gold_ore":		{"def":null,"pickaxe":[{"name":"gold_ore","num":1}]},
	"stone":		{"def":null,"pickaxe":[{"name":"crushed_stone","num":1}]},
	"crushed_stone":{"def":null,"pickaxe":[{"name":"crushed_stone","num":1}]},
	"stone_stove":	{"def":null,"pickaxe":[{"name":"stone_stove","num":1}]},
	"relic_stone":	{"def":null,"pickaxe":[{"name":"relic_stone","num":1}]},
#斧子
	"wood":			{"def":[{"name":"wood","num":1,"random":100}]},
	"wood_board":	{"def":[{"name":"wood_board","num":1,"random":100}]},
	"workbench":	{"def":[{"name":"workbench","num":1,"random":100}]},
	"wood_box":		{"def":[{"name":"wood_box","num":1,"random":100}]},
	
#剪刀,剑
	"leaf":			{"def":[{"name":"wood_stick","num":1,"random":30},{"name":"apple","num":1,"random":5},{"name":"oak_seed","num":1,"random":15}]},
	"leaf_dead":	{"def":[{"name":"wood_stick","num":1,"random":30},{"name":"apple","num":1,"random":5}]},
#大型设备
	"big_stone_stove":{"def":null,"pickaxe":[{"name":"stone_stove","num":1,"random":100}]},
	"high_stone_stove":{"def":null,"pickaxe":[{"name":"stone_stove","num":1,"random":100}]},
	"big_stone_stove_wall":{"def":null,"pickaxe":[{"name":"stone","num":1,"random":100}]},
#扳手
	"wood_gear":	{"def":[{"name":"wood_gear","num":1}]},
#信号
	"button":		{"def":[{"name":"button","num":1}]},
	"pull_rod":		{"def":[{"name":"pull_rod","num":1}]},
	"door":			{"def":[{"name":"door","num":1}]},
	"door0":		{"def":[{"name":"door","num":1}]},
	"torch":		{"def":[{"name":"torch","num":1}]},
	"pressure_board":{"def":[{"name":"pressure_board","num":1}]},
#植物
	"wheat_seed":	{"def":[{"name":"wheat_seed","num":1}]},
	"paddy_seed":	{"def":[{"name":"paddy_seed","num":1}]},
	"oak_seed":	{"def":[{"name":"oak_seed","num":1}]},
	"herb":	{"def":[{"name":"herb","num":1}]},
#other
	"ladder":	{"def":[{"name":"ladder","num":1}]},
	"wood_vat":	{"def":[{"name":"wood_vat","num":1}]},
	"funnel":{"def":[{"name":"funnel","num":1}]},
}