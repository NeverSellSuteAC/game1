class_name Skill
extends Reference

# 技能objId
var _skill_id = null
# 图片资源
export var img= "res://atk/img/攻.png"
# 技能名称
export var name= "普攻"
# 技能描述
export var describe = "进行一次攻击"
# 基础消耗
export var baseXH = 10 
# 百分比,后续会增加其他百分比
export var ratio = 0.1 
# 技能id
export var id= 1
# 技能类型
export var type = "攻"
# 攻击力,目前这个攻击力是指的攻击系数
export var atk = 1
# 攻击释放时间
export var atkTime = 1
# 攻击目标分组,true代表攻击对方,
export var targetGroup = true
# 技能cd,目前技能cd仅对玩家有效
export var cd = 1
# 攻击目标数量
export var atkMore = 1
# 运行cd
var runCd = null
# 技能等级
var level = null

# 方便使用整理的data属性
var data = {
	"name" : name,
	"img" : img,
	"describe" : describe,
	"baseXH" : baseXH,
	"ratio" : ratio,
	"id" : id,
	"type" : type,
	"atk" : atk,
	"atkTime" : atkTime,
	"targetGroup" : targetGroup,
	"cd" : cd,
	"atkMore" : atkMore,
	"level" : level ,
	"runCd" : runCd,
}

func _init(skillData: Dictionary = {}):
	_skill_id = randi()
	# 子类继承时对属性进行修改调整
	initData()
	# 根据不同玩家属性进行数值调整
	for key in skillData:
		if self.get(key) == null:
			self.set(key, skillData.get(key))


func initData():
	pass

# 攻击时调用方法
func run(player,atkTargetList):
	# 受影响的对象id数组
	var targetIdList = []
	# 多重目标判断
	var atkObjList = getAtkTargetList(atkTargetList)
	if atkObjList.size() <= 0:
		return targetIdList
	# 技能计算
	for target in atkObjList:
		var baseAtk = atk * player.get("atk")
		var baseDefense = target.get("defense")
		var realAtk = baseAtk - baseDefense
		target.health -= realAtk
		targetIdList.append(target.id)
	return targetIdList

func getAtkTargetList(atkTargetList):
	var atkObjList = []
	var i = 0
	for atkTarget in atkTargetList:
		# 个数判断
		if i == atkMore:
			break
		# 目标状态判断
		if atkTarget.health <= 0:
#			continue
			pass
		atkObjList.append(atkTarget)
		i += 1
	return atkObjList

func getData():
	return data
