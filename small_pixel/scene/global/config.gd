extends Node
#var LanguageArr=["zh","en","ja","es","ru","fr","de","tr","ko","pl","pt","da","nl","it","uk","bg","hi","ar"]
#var LanguageString=["中文(简体)","English","日本语","España","Россия","France","Deutschland","Türkiye","한국","Polski","Portugal","Danmark","Nederland","Italia","Україна","български","हिन्दी","عربي"]
var LanguageArr=["zh","en","ja","es","ru","fr","de","tr","ko","pl","pt","da","nl","it","uk","bg"]
var LanguageString=["中文(简体)","English","日本语","España","Россия","France","Deutschland","Türkiye","한국","Polski","Portugal","Danmark","Nederland","Italia","Україна","български"]
#var LanguageArr=["zh","en","ja","es"]
#var LanguageString=["中文(简体)","English","日本语","España"]

var mode={
	"build":0,
	"build_bg":1,
	"hurt_mode":2
}
var items_max={
	"block":99,
	"liquid":99,
	"item":99,
	"seed":99,
	"func_item":1,
	"func_items":10,
	"gear":99,
	"switch":99,
	"tool":1,
	"light":99,
	"food":99
}
var item={
	"name":null,
	"num":0,
	"health":0
}
var tools={
}
var blocks={

}
var liquids={
}
var items_type={

}
var scripts={
}
#var synthesis={
#	""
#}
var compound_table={}
var stove_table={}
var fuels={}
var textures={}
var scenes={}
var anms={}
var drops={}
var plants={}
var foods={}
var status={}
var sounds={}

var containers_liquid={
	"wood_barrel_water":{"name":"water","change":"wood_barrel"},
}
var containers=[
	"wood_barrel"
]
var box=[
	"wood_box","stone_stove","big_stone_stove","high_stone_stove",
]
var open=[
	"funnel","torch","water"
]
func _ready():
	blocks=Blocks.data
	liquids=Liquids.data
	scripts=Scripts.data
	drops=Drops.data
	compound_table=Compound_table.data
	stove_table=Stove_table.data
	fuels=Fuels.data
	textures=Textures.data
	tools=Tools.data
	items_type=Items_type.data
	scenes=Scenes.data
	anms=Anms.data
	plants=Plants.data
	foods=Foods.data
	status=Status.data
	sounds=Sounds.data
	pass
func GetConfig(key):
	return self[key]
