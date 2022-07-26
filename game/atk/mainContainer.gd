extends MarginContainer

onready var playerNode = load("res://atk/player.tscn")

onready var atkGroup1 = $main/atkGroup1
onready var atkGroup2 = $main/atkGroup2

# 游戏状态
var status = 1
var statusChange = 1
# 参战玩家数据列表
var dataList = {}
# 参战玩家对象列表
var playerObjList = {}
# 设置根节点
var treeNode = null
func _ready():
	pass # Replace with function body.

# 初始化玩家对象
func initPlayerList():
	for playerId in dataList:
		var playerData = dataList.get(playerId)
		var playerObj = playerNode.instance()
		playerObj.setData(playerData)
		if playerData.atkGroup == 1:
			atkGroup1.add_child(playerObj)
		elif playerData.atkGroup == 2:
			atkGroup2.add_child(playerObj)
		playerObjList[playerData.id] = playerObj
		playerObj.connect("playerDie", treeNode, "_on_playerDie")

func _physics_process(delta):
	if status == 2 and statusChange == 1:
		pauseGame(2)
		statusChange = 2
		pass
	if status == 1 and statusChange == 2:
		pauseGame(1)
		statusChange = 1

# 暂停游戏
func pauseGame(status):
	for playerObjId in playerObjList:
		var playerObj = playerObjList[playerObjId]
		playerObj.pauseGame(status)
	pass

# 设置参战玩家列表数据
func setDataList(dataList):
	self.dataList = dataList

# 设置记录根节点
func setTreeNode(node):
	treeNode = node

func getPlayer(id):
	return playerObjList.get(id)
