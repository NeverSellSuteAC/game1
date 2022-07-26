class_name Skill_5
extends Skill

var buff_id = 1

func _init(skillData: Dictionary = {}).(skillData):
	pass

func initData():
	# 图片资源
	img= "res://atk/img/气.png"
	# 技能名称
	name= "气"
	# 技能描述
	describe = "加强atk几个回合"
	# 基础消耗
	baseXH = 10 
	# 百分比,后续会增加其他百分比
	ratio = 0.1 
	# 技能id
	id= 5
	# 技能类型
	type = "气"
	# 攻击力,目前这个攻击力是指的攻击系数
	atk = 20
	# 攻击释放时间
	atkTime = 1
	# 攻击目标分组,true代表攻击对方,
	targetGroup = false
	# 技能cd,目前技能cd仅对玩家有效
	cd = 5
	# 攻击目标数量
	atkMore = 1
	# 运行cd
	runCd = null
	# 技能等级
	level = null

# 攻击时调用方法
func run(player,atkTargetList):
	var buff = Config.buffList.get(buff_id).duplicate(true)
	buff.time = 10
	buff.buffId = randi()
	player.buffList.append(buff)
	
	# 受影响的对象id数组
	var targetIdList = []
	targetIdList.append(player.id)
	player.atk += buff.atk
	return targetIdList
