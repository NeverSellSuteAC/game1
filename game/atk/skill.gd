extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween = $Tween

# 展示技能面板
signal showSkill
# 关闭技能面板
signal noShowSkill
# 点击技能
signal skillClick
# buff到期
signal buffEnd

# 技能底色
onready var panel = $PanelContainer
# 技能图标
onready var texture = $PanelContainer/TextureRect
# 技能消耗量
onready var xh = $Node2D/xh
# 技能CD
onready var cd = $PanelContainer/cd

# 技能数据
var data = 	{
		"name" : "普攻",
		"id" : 1,
		"type" : "攻",
		"攻击力" : 1 ,
		"baseXH" : 10 ,
		"ratio" : 0.1 ,
		"level" : 1 ,
}
var informationNode = null
var showXH = true
# 技能状态 buff倒计时运行状态
var stauts = 1
var cdStatus = true
# 点击间隔
var clickTime = 0
var modulateValue = 1
var positionValue = 0
var atkGroup = 1
# 消失时间和距离
var tweenTime = 0.5
var endPostion = -100
# 类型:1是技能,2是buff
var type = 1
func _ready():
	if type == 1:
#		getSkillInformation(data.id)
		panel['custom_styles/panel']['bg_color'] = getSkillBg(data.type,"id","level")
		panel['custom_styles/panel']['border_color'] = getSkillBoder(data.type,"id","level")
		if showXH == true:
			xh.text = str(getXH(data.baseXH,1,data.ratio,"playerConfig"))
			cd.setData(data)
		else:
			removeCd()
	elif type == 2:
		buffInit()
#	texture.texture = load(str(getSkillImg(data.id)))
	texture.texture = load(data.img)


func buffInit():
	panel['custom_styles/panel']['bg_color'] = getBuffBg(data.type,"id","level")
	panel['custom_styles/panel']['border_color'] = getBuffBoder(data.type,"id","level")
	xh.text = str(stepify(data.time,0.1))
	endPostion = -60
#	yield(get_tree(),"idle_frame")
#	self.rect_scale.x = 0.5
#	self.rect_scale.y = 0.5

func _physics_process(delta):
	if modulateValue > 0 and modulateValue < 1:
		self.modulate = Color(1,1,1,modulateValue)
#		self.rect_position.x = positionValue
		if type == 1:
			if atkGroup == 1:
				self["custom_constants/margin_left"] = positionValue
			else:
				self["custom_constants/margin_right"] = positionValue
		elif type == 2:
			self["custom_constants/margin_top"] = positionValue
	if modulateValue == float(0):
		self.queue_free()
		if informationNode != null:
			informationNode.queue_free()
			pass
	if clickTime > 0 :
		clickTime -= delta
	if type == 2 and stauts == 1:
		if data.time >0:
			data.time -= delta
			xh.text = str(stepify(data.time,1))
		else:
			if not tween.is_active():
				emit_signal("buffEnd", data)
				self.queueFree()
	
# 暂停游戏
func pauseGame(status):
	self.stauts = status
	if tween.is_active():
#	if true:
		if status == 2:
			tween.set_active(false)
		else:
			tween.set_active(true)
	if cd != null:
		cd.pauseSkillCD(status)

# 设置技能cd
func setSkillCd():
	cd.start(data.cd)
	cdStatus = true

# 设置技能runCd
func _setSkillRunCd(cd):
	data.runCd = cd

# 通过技能id获取技能基础数据信息
func getSkillInformation(id):
	var skillBaseData = Config.skillList[id]
	for item in skillBaseData.data:
		if data.get(item) == null:
			data[item] = skillBaseData[item]

# 获取技能消耗
func getXH(base,level,ratio,playerConfig):
	var baseXH = base * (1 + ((level - 1) * ratio))
	if playerConfig == null:
		return baseXH
	# 进行玩家判断
	var playerXH = baseXH
	return playerXH

# 获取技能图片
func getSkillImg(id):
	return Config.skillList[id].img

# 获取技能背景颜色
func getBuffBg(type,id,level):
	# 暂时只根据类型来判断
	match type:
		"攻":
			return Color(0.84,0.19,0.10,0.14)
		"防":
			return Color(0.10,0.27,0.84,0.14)
		"气":
			return Color(0.09,0.40,0.03,0.14)
		"禁":
			return Color(0.74,0.08,0.74,0.14)

# 获取技能边框颜色
func getBuffBoder(type,id,level):
	match type:
		"攻":
			return Color(0.84,0.19,0.10)
		"防":
			return Color(0.10,0.27,0.84)
		"气":
			return Color(0.09,0.40,0.03)
		"禁":
			return Color(0.74,0.08,0.74)

# 获取技能背景颜色
func getSkillBg(type,id,level):
	# 暂时只根据类型来判断
	match type:
		"攻":
			return Color(0.84,0.19,0.10,0.14)
		"防":
			return Color(0.10,0.27,0.84,0.14)
		"气":
			return Color(0.09,0.40,0.03,0.14)
		"禁":
			return Color(0.74,0.08,0.74,0.14)

# 获取技能边框颜色
func getSkillBoder(type,id,level):
	match type:
		"攻":
			return Color(0.84,0.19,0.10)
		"防":
			return Color(0.10,0.27,0.84)
		"气":
			return Color(0.09,0.40,0.03)
		"禁":
			return Color(0.74,0.08,0.74)

func setData(data):
	self.data = data

func removeCd():
	cd = null
	$PanelContainer/cd.queue_free()
#	$PanelContainer.remove_child($PanelContainer/cd)

func queueFree(atkGroup: int = 1):
	tween.interpolate_property(self, "modulateValue", modulateValue, 0, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()
	
	
	self.atkGroup = atkGroup
	tween.interpolate_property(self, "positionValue", positionValue, endPostion, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()

# 鼠标移入事件
func _on_PanelContainer_mouse_entered():
	emit_signal("showSkill", data, self)

# 鼠标移出事件
func _on_PanelContainer_mouse_exited():
	emit_signal("noShowSkill", self)

# cd恢复
func _on_cd_cdOk():
	cdStatus = false

# 鼠标点击监听
func _on_PanelContainer_gui_input(event):
	if event.is_action_released("mouse_click") and clickTime <= 0 :
		clickTime = 0.2
		emit_signal("skillClick", data.id)
