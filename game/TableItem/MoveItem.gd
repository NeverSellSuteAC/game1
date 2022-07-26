extends Node2D

onready var panel = $ItemBorder
onready var imgText = $ItemBorder/ItemImg
onready var numLabel = $ItemBorder/ItemNum

var defaultImg = load("res://img/item_bg.png")
var defaultColor = Color(0, 0, 0, 0)
var data = {
	"name" : "真*神*极*板砖",
	"img":defaultImg,
	"color":defaultColor,
	"num":0,
	"type" : Config.propType.gemstone,
	"level" : 1,
	"base" : {
		"速度:" : 1,
		"攻击:" : 2,
		"等级:" : 3,
		"生命:" : 4,
		"护甲:" : 5,
		"魔法:" : 6
	},
}
# 状态枚举
enum State {
	ON,
	OFF,
	MOVE,
	DOWN
}
const ON = 0
const OFF = 1
const MOVE = 2
const DOWN = 3
# 当前状态
var currentState = 1

func _ready():
	InitItem()


func InitItem():
	panel['custom_styles/panel']['border_color'] = data.color
	imgText['texture'] = data.img
	if data.num == 1:
		numLabel.text = ""
	elif data.num != 0:
		numLabel.text = str(data.num)
	else:
		numLabel.text = ""


func SetData(data):
	if data != null:
		self.data = data

func _process(delta):
	if currentState == State.MOVE and MouseClick() and Config.mouse_click_move:
		global_position = get_global_mouse_position()
	if currentState == State.MOVE and !MouseClick() and Config.mouse_click_move:
		currentState = State.ON
		Config.mouse_click_move = false
		queue_free()
	
# 鼠标事件判断
func MouseClick():
	return Input.is_action_pressed("mouse_click")
