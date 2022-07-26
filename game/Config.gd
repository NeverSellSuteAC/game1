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
# buff
var buff1 = load("res://atk/skill/buff_1.gd")
var buff2 = load("res://atk/skill/buff_2.gd")
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


var skillList = {}
var buffList = {}

# 加载技能列表
func skillLoad():
	var path = "res://atk/skill"
	var type = "skill_"
	var list = dir_contents(path, type)
	for fileName in list:
		skillList[skillList.size() + 1] = load(fileName)
# 加载buff列表
func buffLoad():
	var path = "res://atk/skill"
	var type = "buff_"
	var list = dir_contents(path, type)
	for fileName in list:
		buffList[buffList.size() + 1] = load(fileName)
	

func dir_contents(path, type):
	var list = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				pass
				if file_name.find(type) >= 0:
					list.append(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("尝试访问路径时出错。")
	return list


func atkChange(playerData, buff):
	playerData.atk -= buff.atk
	pass

#####################################################################
#######################    消消乐   ##################################
#####################################################################
export var mouse_click_xxl = false
