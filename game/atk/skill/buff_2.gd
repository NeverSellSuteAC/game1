class_name Buff_2
extends Buff


func _init(skillData: Dictionary = {}).(skillData):
	pass

func initData():
	# 图片资源
	img = "res://atk/img/禁.png"
	# 技能名称
	name = "禁"
	# 技能描述
	describe = "攻击降低"
	# 百分比,后续会增加其他百分比
	ratio = 0.1 
	# 技能id
	id = 2
	# 技能类型
	type = "禁"
	# 攻击力,目前这个攻击力是指的攻击系数
	atk = -20
	# 技能等级
	level = null

# 攻击时调用方法
func buffEnd(playerData):
	playerData.atk -= atk

