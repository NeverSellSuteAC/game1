extends MarginContainer


onready var skillInformationPanel = load("res://InformationPanel/SkillInformationPanel.tscn")
onready var skillNode = load("res://atk/skill.tscn")


var treeNode = null
# 游戏运行状态
var status = 1
var statusChange = 1
# 查询出来的玩家技能列表
var skillList = []
# 玩家技能列表对象
var skillObjList = []
# 当前鼠标展示技能
var skillData = null
# 当前鼠标展示技能面板信息对象
var skillInformationPanelObj = null

# 初始化
func _ready():
	getSkillList(null)
	skillListInit()

func _physics_process(delta):
	if skillObjList.size() == 0 and treeNode != null:
		skillListInit()
	if status == 2 and statusChange == 1:
		pauseGame(2)
		statusChange = 2
	if status == 1 and statusChange == 2:
		pauseGame(1)
		statusChange = 1

# 暂停游戏
func pauseGame(status):
	for skill in skillObjList:
		if skill.cdStatus:
			skill.pauseGame(status)

# 设置单个技能cd
func setSkillCd(skill):
	for skillObj in skillObjList:
		if skill.id == skillObj.data.id:
			skillObj.setSkillCd()
			break

# 技能列表对象生成
func skillListInit():
	if treeNode == null:
		return
	for skill in skillList:
		var skillObj = skillNode.instance()
		var skillR:Skill = Config.skillList[skill.id].new(PlayerData.skillList.get(skill.id))
		skillObj.setData(skillR)
		$skillContainer/skillList/skillHBox.add_child(skillObj)
		skillObj.connect("showSkill",self,"_on_skill_showSkill")
		skillObj.connect("noShowSkill",self,"_on_skill_noShowSkill")
		skillObj.connect("skillClick",treeNode,"_on_skill_skillClick")
		skillObjList.append(skillObj)



# 获取技能列表
func getSkillList(type):
	if type == null:
#		skillList = PlayerData.skillList
		for skillId in PlayerData.skillList:
			var skill = PlayerData.skillList.get(skillId)
			skillList.append(skill)
	else:
		skillList = skillTypeFilter(type)

# 技能类型筛选
func skillTypeFilter(type):
	var filterList = []
	for skillId in PlayerData.skillList:
		var skill = PlayerData.skillList.get(skillId)
		if skill.type == type:
			filterList.append(skill)
	return filterList

# 输入事件
func _on__gui_input(event, type):
#	if Input.is_action_pressed("mouse_click"):
	# 技能类型筛选按钮点击事件
	if event.is_action_released("mouse_click"):
		print(type)

# 鼠标移入时,显示技能信息面板
func _on_skill_showSkill(data, node):
	if skillData == null :
		skillData = data
		skillInformationPanelObj = skillInformationPanel.instance()
		skillInformationPanelObj.setData(data)
		add_child(skillInformationPanelObj)
	else:
		pass

# 鼠标移出时,清除技能信息展示面板
func _on_skill_noShowSkill(node):
	skillData = null
	if skillInformationPanelObj != null:
		skillInformationPanelObj.queue_free()

# 设置记录根节点
func setTreeNode(node):
	treeNode = node
