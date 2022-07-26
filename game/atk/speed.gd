extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var speedTextureRect = load("res://atk/speedTextureRect.tscn")


# 游戏运行状态
var status = 1
var statusChange = 1
# 参战人员信息列表
var dataList = []
# 参战人员攻击速度移动对象列表式
var speedObjList = []
# 根节点对象
var treeNode = null
# Called when the node enters the scene tree for the first time.
func _ready():
	initSpeedObj()
	pass # Replace with function body.

func _physics_process(delta):
	# 初始化
	if speedObjList.size() ==0 and dataList.size() != 0:
		initSpeedObj()
	# 状态暂停
	if status == 2 and statusChange == 1:
		pauseGame(2)
		statusChange = 2
		pass
	if status == 1 and statusChange == 2:
		pauseGame(1)
		statusChange = 1
	pass

# 暂停游戏
func pauseGame(status):
	for speed in speedObjList:
		speed.pauseGame(status)
		pass
	pass

# 初始化参战人员对象列表,绑定相应信号
func initSpeedObj():
	for data in dataList:
		var speedTextureRectObj = speedTextureRect.instance()
		speedTextureRectObj.setData(data)
		speedTextureRectObj.connect("atkStart",treeNode,"_on_speed_atkStart")
		speedTextureRectObj.connect("atkOver",treeNode,"_on_speed_atkOver")
		$MarginContainer/Node2D.add_child(speedTextureRectObj)
		speedObjList.append(speedTextureRectObj)

# 设置参战人员信息
func setDataList(dataList):
	self.dataList = dataList

# 设置根节点
func setTreeNode(node):
	treeNode = node
