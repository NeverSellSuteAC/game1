class_name Buff
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
}

func _init():
	_skill_id = randi()

func init(skillData: Dictionary = {}):
	initData()
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
