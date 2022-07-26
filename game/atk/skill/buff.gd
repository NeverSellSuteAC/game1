class_name Buff
extends Reference


# 技能objId
var _skill_id = null
# 图片资源
export var img= "res://atk/img/气.png"
# 技能名称
export var name= "气"
# 技能描述
export var describe = "提升攻击力"
# 百分比,后续会增加其他百分比
export var ratio = 0.1 
# 技能id
export var id= 1
# 技能类型
export var type = "气"
# 攻击力,目前这个攻击力是指的攻击系数
export var atk = 20
# 技能等级
var level = null
# buff剩余持续时间
var time = null

# 方便使用整理的data属性
var data = {
	"name" : name,
	"img" : img,
	"describe" : describe,
	"ratio" : ratio,
	"id" : id,
	"type" : type,
	"atk" : atk,
	"level" : level ,
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
func buffEnd(playerData):
	playerData.atk -= atk

func getData():
	return data
