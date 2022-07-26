#class_name Skill_7
#extends Skill
#
#
#func _init(skillData: Dictionary = {}):
#	# 技能本身数据初始化
#	initData()
#	# 技能参数随动赋值,后续自行调整
#	for key in skillData:
#		if self.get(key) == null:
#			self.set(key, skillData.get(key))
#	_skill_id = randi()
#
#func initData():
#	# 图片资源
#	img= "res://atk/img/攻.png"
#	# 技能名称
#	name= "强力重攻"
#	# 技能描述
#	describe = "进行一次强力攻击"
#	# 基础消耗
#	baseXH = 10 
#	# 百分比,后续会增加其他百分比
#	ratio = 0.1 
#	# 技能id
#	id= 7
#	# 技能类型
#	type = "攻"
#	# 攻击力,目前这个攻击力是指的攻击系数
#	atk = 3
#	# 攻击释放时间
#	atkTime = 1
#	# 攻击目标分组,true代表攻击对方,
#	targetGroup = true
#	# 技能cd,目前技能cd仅对玩家有效
#	cd = 1
#	# 攻击目标数量
#	atkMore = 2
#	# 运行cd
#	runCd = null
#	# 技能等级
#	level = null
#
## 攻击时调用方法
#func run(player,atkTargetList):
#	# 受影响的对象id数组
#	var targetIdList = []
#	# 多重目标判断
#	var atkObjList = []
#	var i = 0
#	for atkTarget in atkTargetList:
#		# 个数判断
#		if i == atkMore:
#			break
#		# 目标状态判断
#		if atkTarget.health <= 0:
#			continue
#		atkObjList.append(atkTarget)
#		i += 1
#	if atkObjList.size() <= 0:
#		return targetIdList
#		# 技能计算
#	for target in atkObjList:
#		var baseAtk = atk * player.get("atk")
#		var baseDefense = target.get("defense")
#		var realAtk = baseAtk - baseDefense
#		target.health -= realAtk
#		targetIdList.append(target.id)
#	return targetIdList
#
#func getData():
#	return data
