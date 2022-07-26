extends MarginContainer

signal playerDie

onready var gui = $mainBox/dataBox/GUI
onready var img = $mainBox/dataBox/imgContainer
onready var playerImg = $mainBox/dataBox/imgContainer/TextureRect
onready var dataBox = $mainBox/dataBox
onready var skillBox = $mainBox/skillBox
onready var buffBox = $mainBox/buffBox
onready var buffBox1 = $mainBox/buffBox/buffBox
onready var tween = $mainBox/dataBox/GUI/Tween

onready var levelLable = $mainBox/dataBox/GUI/Bars/HBoxContainer/level/Title
onready var hBox = $mainBox/dataBox/GUI/Bars/HBoxContainer
onready var level = $mainBox/dataBox/GUI/Bars/HBoxContainer/level
onready var healthProgress = $mainBox/dataBox/GUI/Bars/healthProgress
onready var healthLabel = $mainBox/dataBox/GUI/Bars/healthProgress/Label
onready var powerProgress = $mainBox/dataBox/GUI/Bars/HBoxContainer/powerProgress
onready var powerLabel = $mainBox/dataBox/GUI/Bars/HBoxContainer/powerProgress/Label

onready var skillInformationPanel = load("res://InformationPanel/SkillInformationPanel.tscn")
onready var skillNode =  load("res://atk/skill.tscn")

# 游戏状态
var status = 1
var statusChange = 1
var isFilp = false
# 玩家数据
var data = {
	
}
var healthMax = 0
var health = 0
var powerMax = 0
var power = 0
# buff列表
var buffObjList = []
# 技能列表
var skillObjList = []
var skillSize = 5
# 当前鼠标展示技能
var skillData = null
# 当前鼠标展示技能面板信息对象
var skillInformationPanelObj = null
func _ready():
	initData()
	pass # Replace with function body.

func _physics_process(delta):
	var round_value = round(health)
	healthProgress.value = round_value
	
	var round_value_power = round(power)
	powerProgress.value = round_value_power
	
	# 游戏暂停判断
	if status == 2 and statusChange == 1:
		pauseGame(2)
		statusChange = 2
		pass
	if status == 1 and statusChange == 2:
		pauseGame(1)
		statusChange = 1
	
	if data.health <= 0 and status != -1:
		die()

func die():
	emit_signal("playerDie", data)
	status = -1

# 暂停游戏
func pauseGame(status):
	if status == -1:
		return
	for skillObj in skillObjList:
		skillObj.pauseGame(status)
	for buffObj in buffObjList:
		buffObj.pauseGame(status)
		
		
# 数据初始化
func initData():
	# 技能栏目初始化
	buffInit()
	skillInit(-1)
	# 位置处理
	if data.atkGroup == 2:
		flip()
	healthMax = data.healthMax
	health = data.health
	powerMax = data.powerMax
	power = data.power
	healthProgress.max_value = data.healthMax
	healthProgress.value = data.health
	powerProgress.max_value = data.powerMax
	powerProgress.value = data.power
	playerImg.texture = load(data.img)
	pass
	
func buffInit(type: int = 0):
	# 一般初始化
	if type == 0:
		var buffList = data.buffList
		var i = 0
		for buff in buffList:
			var buffObj = createBuffNode(buff)
			buffObjList.append(buffObj)
			i += 1
			if i == skillSize:
				break
		for buffObj in buffObjList:
			buffBox1.add_child(buffObj)
		yield(get_tree(),"idle_frame")
		buffBox1.rect_scale.x = 0.5
		buffBox1.rect_scale.y = 0.5
	elif type == 1 and data.buffList.size() > 0:
		var num = buffObjList.size()
		for buffObj in buffObjList:
			if buffObj == null or buffObj.modulateValue < 1:
				num -= 1
		if data.buffList.size() <= num:
			return
		var buff = data.buffList.back()
		var buffObj = createBuffNode(buff)
		buffObjList.append(buffObj)
		buffBox1.add_child(buffObj)


func getFirstSkill():
	# 判断左右翻转
	if isFilp:
		# 右边
		if skillObjList.size() > data.skillList.size():
			return skillObjList[skillObjList.size() - 2]
		else:
			return skillObjList[skillObjList.size() - 1]
	else:
		# 左边(主要玩家)
		if skillObjList.size() > data.skillList.size():
			return skillObjList[1]
		else:
			return skillObjList[0]

# 需要大修!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!需要大修
func skillInit(type: int = 0):
	# 正常消除增加
	if skillObjList.size() > 0 and type == 0:
		var removeSkillObj
		var skillId = data.skillList[skillSize - 1]
		var skillObj = createSkillNode(skillId)
		
		skillBox.add_child(skillObj)
		if data.atkGroup == 1:
			removeSkillObj = skillObjList.pop_front().queueFree(data.atkGroup)
			skillObjList.append(skillObj)
		else:
			removeSkillObj = skillObjList.pop_back().queueFree(data.atkGroup)
			skillBox.move_child(skillObj, 0)
			skillObjList.insert(0, skillObj)
	# 玩家添加技能到技能列表
	elif type == 3:
		var skillId = data.skillList[1]
		var skillObj = createSkillNode(skillId)
		if skillObjList.size() > data.skillList.size():
			skillBox.add_child_below_node(skillObjList[1], skillObj)
			skillObjList.insert(2, skillObj)
		else:
			skillBox.add_child_below_node(skillObjList[0], skillObj)
			skillObjList.insert(1, skillObj)
		skillObjList.pop_back().queueFree(2)
#		skillObjList.pop_back().queue_free()
	# 一般初始化
	else:
		var i = 0
		for skillId in data.skillList:
			var skillObj = createSkillNode(skillId)
			skillObjList.append(skillObj)
			i += 1
			if i == skillSize:
				break
		if data.atkGroup == 2:
			skillObjList.invert()
		for skillObj in skillObjList:
			skillBox.add_child(skillObj)
# 需要大修!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!需要大修
var ordinaryAtk = load("res://atk/skill/skill.gd")
func createSkillNode(skillId):
	var skillObj = skillNode.instance()
	var skill:Skill = Config.skillList[skillId].new()
	skillObj.setData(skill)
	skillObj.showXH = false
	skillObj.connect("showSkill",self,"_on_skill_showSkill")
	skillObj.connect("noShowSkill",self,"_on_skill_noShowSkill")
	return skillObj

func createBuffNode(buff):
	var buffObj = skillNode.instance()
	buffObj.setData(buff)
	buffObj.type = 2
	buffObj.connect("showSkill",self,"_on_skill_showSkill")
	buffObj.connect("noShowSkill",self,"_on_skill_noShowSkill")
	buffObj.connect("buffEnd",self,"_on_buff_buffEnd")
	return buffObj

# 镜像处理
func flip():
	isFilp = true
	dataBox.move_child(gui,0)
	skillBox.alignment = BoxContainer.ALIGN_END
	levelLable.margin_left = -100
	levelLable.margin_right = 0
	hBox.alignment = BoxContainer.ALIGN_END
	hBox.move_child(level,0)
	healthProgress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT
	powerProgress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT

func getAtkPosition():
	var position = gui.rect_global_position
	if data.atkGroup == 1:
		position.x += gui.rect_size.x
		position.y += (gui.rect_size.y/2)
	else:
		position.y += (gui.rect_size.y/2)
	return position

# 设置玩家数据
func setData(data):
	self.data = data


func _on_healthProgress_mouse_entered():
	healthLabel.text = str(data.health) + "/" + str(data.healthMax)
	healthLabel.modulate = Color(1, 0, 0, 1)


func _on_healthProgress_mouse_exited():
	healthLabel.text = ""
	healthLabel.modulate = Color(1, 0, 0, 0)


func _on_powerProgress_mouse_entered():
	powerLabel.text = str(data.power) + "/" + str(data.powerMax)
	powerLabel.modulate = Color(1, 0, 0, 1)


func _on_powerProgress_mouse_exited():
	powerLabel.text = ""
	powerLabel.modulate = Color(1, 0, 0, 0)

# buff消失
func _on_buff_buffEnd(data):
	data.buffEnd(self.data)
	var index = null
	var i = 0
	for buff in self.data.buffList:
		if data._skill_id == buff._skill_id:
			index = i
		i += 1
	self.data.buffList.remove(index)
	self.buffObjList.remove(index)

func healthUpdate():
	tween.interpolate_property(self, "health", health, data.health, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()

func powerUpdate():
	tween.interpolate_property(self, "power", power, data.power, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()

# 鼠标移入时,显示技能信息面板
func _on_skill_showSkill(data, node):
	if skillData == null :
		skillData = data
		skillInformationPanelObj = skillInformationPanel.instance()
		skillInformationPanelObj.setData(data)
		add_child(skillInformationPanelObj)
		if node != null:
			node.informationNode = skillInformationPanelObj
	else:
		pass
	pass # Replace with function body.

# 鼠标移出时,清除技能信息展示面板
func _on_skill_noShowSkill(node):
	skillData = null
	if skillInformationPanelObj != null and !skillInformationPanelObj.is_queued_for_deletion() :
		skillInformationPanelObj.queue_free()
		if node != null:
			node.informationNode = null



