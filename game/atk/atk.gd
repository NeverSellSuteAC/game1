extends Node2D

onready var atkLine = load("res://atk/atkLine.tscn")

signal guiUpdate

onready var speed = $atkContainer/VBoxContainer/speed
onready var mainContainer = $atkContainer/VBoxContainer/mainContainer
onready var skill = $atkContainer/VBoxContainer/skill

var playerDataList = {}
# Called when the node enters the scene tree for the first time.
# 游戏运行状态2
var status = 1
# 游戏暂停间隙
var spaceTime = 0.05
var skillSize = 5
var skillClickTime = 1
func _ready():
	randomize()
	initAtkList()
	pass # Replace with function body.


func _physics_process(delta):
	if skillClickTime > 0:
		skillClickTime -= delta
	spaceTime += delta
	if Input.is_action_pressed("space") and status == 1 and spaceTime >= 0.5:
		status = 2
		pauseGame(status)
#		get_tree().paused = true
		spaceTime = 0
	if Input.is_action_pressed("space") and status == 2 and spaceTime >= 0.5:
		status = 1
		pauseGame(status)
#		get_tree().paused = false
		spaceTime = 0

# 技能开始蓄力
func _on_speed_atkStart(id,node):
#	print("start:"+str(id))
	var playerSkill = getAtkSkill(id)
	print(playerSkill.get("atkTime"))
	node.setAtkTime(playerSkill.atkTime)

# 技能蓄力完毕
func _on_speed_atkOver(id,node):
#	print("over:"+str(id))
	var playerSkill = getAtkSkill(id, true)
	runSkill(playerSkill,id)
	node.status = 1

###########################################正式释放技能###########################################
# 正式释放技能
func runSkill(skill,id):
#	print(skill)
	var player = playerDataList.get(id)
	var targetGroup = 1 if skill.get("targetGroup") == true else 2
	if player.atkGroup == 2:
		targetGroup = 2 if targetGroup == 1 else 1
	var atkTargetList = getTargetList(player,targetGroup)
	
	if player.atkGroup == 1:
		print(player.atk)
	
	# 技能执行
	var targetIdList = skill.run(player,atkTargetList)
	
	# 攻击触发点
	var atkStartPosition = mainContainer.playerObjList[id].getAtkPosition()
	# ui变化,数据更新
	for id in targetIdList:
		var playerGuiObj = mainContainer.playerObjList[id]
		playerGuiObj.healthUpdate()
		playerGuiObj.buffInit(1)
		# 攻击指向线
		# 攻击目标点
		var atkEndPosition = playerGuiObj.getAtkPosition()
		drawAtk(atkStartPosition, atkEndPosition, player.atkGroup)
	
	# 技能列表界面刷新
	var playerGuiObj = mainContainer.playerObjList[id]
	playerGuiObj.skillInit()
	
	if id == 1:
		# 设置技能cd
		var playerSkill = PlayerData.skillList.get(skill.id)
		playerSkill.runCd = skill.cd
		self.skill.setSkillCd(skill)
###########################################正式释放技能###########################################

func drawAtk(atkStartPosition, atkEndPosition, atkGroup):
	var drawAtkDeviation = Vector2(0, 0)
	if atkGroup == 2:
		drawAtkDeviation = Vector2(0, -20)
	var atkLineObj = atkLine.instance()
	atkLineObj.setData(atkStartPosition + drawAtkDeviation, atkEndPosition + drawAtkDeviation)
	add_child(atkLineObj)


# 获取技能可选目标列表
func getTargetList(player,targetGroup):
	var targetList = []
	for id in playerDataList:
		var target = playerDataList.get(id)
		if targetGroup != target.get("atkGroup"):
			targetList.append(target)
	return targetList

# 玩家技能插入
func _on_skill_skillClick(skillId):
	if skillClickTime >0 :
		return
	var player = playerDataList.get(1)
	var playerSkillList = player.get("skillList")
	playerSkillList.insert(1,skillId)
	# 玩家技能列表界面刷新 
	var playerGuiObj = mainContainer.playerObjList[1]
	playerGuiObj.skillInit(3)
	skillClickTime = 1
	print(playerSkillList)
	

# 获取目标待释放技能,使用技能后,移出待释放技能列表
func getAtkSkill(id, isRemove: bool = false):
	var player = playerDataList.get(id)
	var playerObj = mainContainer.getPlayer(id)
	
	# 新方法
	var playerSkillList = player.get("skillList")
	var playerSkillObj = playerObj.getFirstSkill()
	# 旧方法
#	var playerSkill = Config.skillList[playerSkillList[0]].new()
	if isRemove:
		playerSkillList.remove(0)
		if playerSkillList.size() <= skillSize:
			playerSkillList.append(1)
	
	return playerSkillObj.data

# 初始化对战信息
func initAtkList():
	var atkListData = []
	atkListData = [
		{
			"id": 1,
			"name" : "玩家",
			"img": "res://atk/img/攻.png",
			"speed": 500,
			"skillList":[1,1,1,1,1,1],
			"atkGroup": 1,
			"health": 100,
			"healthMax": 200,
			"defense": 10,
			"ling" : 100,
			"atk" : 20,
			"powerMax": 500,
			"power": 500,
			"buffList": [
				{
					"id": 1,
					"time": 30,
					"buffId" : randi(),
				},
				{
					"id": 2,
					"time": 3,
					"buffId" : randi(),
				},
			],
		},
		{
			"id": 2,
			"name" : "小怪1",
			"img": "res://atk/img/气.png",
			"speed": 800,
			"skillList":[1,1,1,1,1,1],
			"atkGroup": 2,
			"health": 3000,
			"healthMax": 400,
			"defense": 10,
			"ling" : 100,
			"atk" : 20,
			"powerMax": 500,
			"power": 500,
			"buffList": [],
		},
		{
			"id": 3,
			"name" : "小怪2",
			"img": "res://atk/img/防.png",
			"speed": 20,
			"skillList":[1,1,1,1,1,1],
			"atkGroup": 2,
			"health": 400,
			"healthMax": 500,
			"defense": 10,
			"ling" : 100,
			"atk" : 20,
			"powerMax": 500,
			"power": 500,
			"buffList": [],
		}
	]
	for player in atkListData:
		playerDataList[player.id] = player
	self.speed.setDataList(atkListData)
	self.speed.setTreeNode(self)
	self.skill.setTreeNode(self)
	self.mainContainer.setTreeNode(self)
	self.mainContainer.setDataList(playerDataList)
	self.mainContainer.initPlayerList()

# 暂停游戏
func pauseGame(newStatus):
	speed.status = newStatus
	mainContainer.status = newStatus
	skill.status = newStatus

