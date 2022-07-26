extends Node2D

onready var defaultImg = load("res://img/item_bg.png")
onready var img = defaultImg

var defaultData = {
	"名字":0,
	"生命上限":1,
	"生命":1,
	"灵力上限":2,
	"灵力":2,
	"境界":3,
	"防御":4,
	"速度":5,
	"物品":{
		
	},
	"装备":{
		
	},
	"技能":{
		
	}
}

var data = {
	
}

# type是指队友:0.怪物:1~11111,怪物同时还代表特殊怪物种类
var type = "1"
# 队列排序.相当于界面上的上下顺序
var index = 0
# 速度
var speed = 2
# 当前速度进行时间
var speedTime = 0
# 当前状态,有:
# atk:攻击施法中,部分技能需要施法时间,
# wait:等待,每次攻击间隔,
var status = "wait"
# 持续性状态列表
# vertigo:眩晕,暂停/打断动作,
# slow:迟缓,回合等待延长,攻击施法延长,
# 禁魔:无法使用技能
var buffList = []
# 个人回合数,因为有速度影响回合,所以这个目前只做记录
var rounds = 0
func _ready():
	
	pass # Replace with function body.

func _physics_process(delta):
	speedTime += delta
	if status == "wait" and speedTime < speed:
		pass
	else:
		status = "atk"
		atk()
		pass
	pass

func atk():
	status = "wait"
	pass
