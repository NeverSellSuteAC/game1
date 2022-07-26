extends Node

export var mo_max_number = 5
export var mo_number = 0
export var mo_time = 1
export var mo_process_time = 0
# fox属性
export var mo_fox_default_speed = 200
export var mo_fox_default_atk = 100
export var mo_fox_default_level = 1
export var mo_fox_default_health = 10000
export var mo_fox_default_armor = 1
export var mo_fox_default_magic = 0
export var mo_fox_default_exp = 5
# 英雄属性
export var player_dog_default_speed = 400
export var player_dog_default_atk_time = 0.0001
export var player_dog_default_atk = 5

var ordinaryAtk = load("res://atk/skill/skill.gd")
var ordinaryAtk1 = load("res://atk/skill/skill_1.gd")
var ordinaryAtk2 = load("res://atk/skill/skill_2.gd")
var ordinaryAtk3 = load("res://atk/skill/skill_3.gd")
var ordinaryAtk4 = load("res://atk/skill/skill_4.gd")
var ordinaryAtk5 = load("res://atk/skill/skill_5.gd")
var ordinaryAtk6 = load("res://atk/skill/skill_6.gd")
# 鼠标背包点击按下抬起状态
export var mouse_click_move = false
# 道具属性
const propType = {
	gemstone = "宝石"
}

# 通过技能id获取技能基础数据信息
func addData(data, addData):
	for item in addData:
		if data.get(item) == null:
			data[item] = addData[item]

##################技能#########
# 普攻
func atk(skill,player,atkTargetList):
	# 受影响的对象id数组
	var targetIdList = []
	# 多重目标判断
	var atkObjList = []
	if skill.has("atkMore") and skill.get("atkMore") >1:
		var i = 0
		for atkTarget in atkTargetList:
			# 个数判断
			if i == skill.get("atkMore"):
				break
			# 目标状态判断
			if atkTarget.health <= 0:
				continue
			atkObjList.append(atkTarget)
			i += 1
	else:
		atkObjList.append(atkTargetList[0])
	if atkObjList.size() <= 0:
		return targetIdList
		# 技能计算
	for target in atkObjList:
		var baseAtk = skill.get("atk") * player.get("atk")
		var baseDefense = target.get("defense")
		var realAtk = baseAtk - baseDefense
		target.health -= realAtk
		targetIdList.append(target.id)
	return targetIdList


# 添加攻击buff
func addAtk(skill,player,atkTargetList):
	var buff = buffList.get(skill.buff_id).duplicate(true)
	buff.time = 10
	buff.buffId = randi()
	player.buffList.append(buff)
	
	# 受影响的对象id数组
	var targetIdList = []
	targetIdList.append(player.id)
	player.atk += buff.atk
	return targetIdList


var skillList = {
	1:ordinaryAtk1,
	2:ordinaryAtk2,
	3:ordinaryAtk3,
	4:ordinaryAtk4,
	5:ordinaryAtk5,
	6:ordinaryAtk6,
}
var buffList = {
	1:{
		"img": "res://atk/img/气.png",
		"name": "气招",
		"describe": "加强atk几个回合",
		"baseXH" : 10 ,
		"ratio" : 0.1 ,
		"id": 1,
		"type" : "气",
		"atk" : 20 ,
		"atkTime": 1,
		"run" : funcref(self,"atk"),
		"buffEnd" : funcref(self,"atkChange"),
		"targetGroup" : false,
		"cd" : 1,
	},
	2:{
		"img": "res://atk/img/禁.png",
		"name": "禁招",
		"describe": "封禁技能几个回合",
		"baseXH" : 10 ,
		"ratio" : 0.1 ,
		"id": 2,
		"type" : "禁",
		"atk" : -20 ,
		"atkTime": 5,
		"run" : funcref(self,"atk"),
		"buffEnd" : funcref(self,"atkChange"),
		"targetGroup" : true,
		"cd" : 1,
	},
}

func atkChange(playerData, buff):
	playerData.atk -= buff.atk
	pass

#####################################################################
#######################    消消乐   ##################################
#####################################################################
export var mouse_click_xxl = false
