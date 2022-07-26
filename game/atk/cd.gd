extends MarginContainer


signal cdOk

onready var tween = $Tween
onready var progress = $Progress
onready var text = $text

# cd遮罩圈
var progressValue = 0
# cd值
var time = 5
# Called when the node enters the scene tree for the first time.
# 游戏状态
var status = 1
# cd状态
var timeStart = 1
# 技能数据
var data = {}
func _ready():
#	start(5)
	text.text = ""
	progress.value = progressValue
	pass # Replace with function body.

func _physics_process(delta):
	if time != 0 and timeStart == 2:
		var cd = stepify(time,0.1)
		data.runCd = cd
		text.text = str(cd)
		progress.value = progressValue
	elif time == 0 and timeStart == 2:
		text.text = ""
		progress.value = progressValue
		timeStart = 1
		emit_signal("cdOk")
		time = 5
	pass

# 暂停游戏
func pauseSkillCD(status):
	if status == 2:
		tween.set_active(false)
	else:
		tween.set_active(true)
	pass

# cd开始
func start(time):
	timeStart = 2
	tween.interpolate_property(self, "progressValue", 360, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()
	tween.interpolate_property(self, "time", time, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()

func setData(data):
	self.data = data
