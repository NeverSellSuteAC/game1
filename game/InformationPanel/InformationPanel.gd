extends Node2D


onready var nameLable = $PanelContainer/Border/All/Head/Title/Name
onready var typeLable = $PanelContainer/Border/All/Head/Title/TitleInformation/Type
onready var levelLable = $PanelContainer/Border/All/Head/Title/TitleInformation/Level
onready var baseBox = $PanelContainer/Border/All/Details/Base
onready var specialBox = $PanelContainer/Border/All/Details/Special
onready var item = $PanelContainer/Border/All/Head/TableBorder
#onready var nameLable = $PanelContainer/All/Head/Title/Name
#onready var typeLable = $PanelContainer/All/Head/Title/TitleInformation/Type
#onready var levelLable = $PanelContainer/All/Head/Title/TitleInformation/Level
#onready var baseBox = $PanelContainer/All/Details/Base
#onready var specialBox = $PanelContainer/All/Details/Special
#onready var item = $PanelContainer/All/Head/TableBorder


onready var leble = load("res://Label.tscn")

var propName = "真*神*极*板砖"
var img = null
var color = null
var type = Config.propType.gemstone
var level = 1
var base = {
	"速度:" : 1,
	"攻击:" : 2,
	"等级:" : 3,
	"生命:" : 4,
	"护甲:" : 5,
	"魔法:" : 6
}
var baseList = []
var special = []

func _ready():
	InitData()


func InitData():
	nameLable.text = "  " + propName
	typeLable.text = "  " + Config.propType.gemstone
	levelLable.text = "等级限制:" + str(level) + "   "
	item.SetData({
			"img":img,
			"color":color
		}
	)
	for key in base:
		var label = leble.instance()
		baseBox.add_child(label)
		label.text = str(key) + str(base[key])
		baseList.append(label)
		


func setData(data):
	propName = data["name"] + ":" + str(data.num)
	img = data.img
	color = data.color
	type = data.type
	level = data.level
	base = data.base
	

func _process(delta):
	position = get_global_mouse_position()
	position.x += 2
	position.y += 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
