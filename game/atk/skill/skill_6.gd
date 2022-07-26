class_name Skill_6
extends Skill

var buff_id = 2

func _init(skillData: Dictionary = {}).(skillData):
	pass

func initData():
	# 图片资源
	img= "res://atk/img/禁.png"
	# 技能名称
	name= "禁"
	# 技能描述
	describe = "封禁技能几个回合"
	# 基础消耗
	baseXH = 10 
	# 百分比,后续会增加其他百分比
	ratio = 0.1 
	# 技能id
	id= 6
	# 技能类型
	type = "禁"
	# 攻击力,目前这个攻击力是指的攻击系数
	atk = -20
	# 攻击释放时间
	atkTime = 1
	# 攻击目标分组,true代表攻击对方,
	targetGroup = true
	# 技能cd,目前技能cd仅对玩家有效
	cd = 1
	# 攻击目标数量
	atkMore = 1
	# 运行cd
	runCd = null
	# 技能等级
	level = null

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
		var buff = Config.buffList[buff_id].new()
		buff.time = 10
		target.buffList.append(buff)
		target.atk += buff.atk
		targetIdList.append(target.id)
	return targetIdList
