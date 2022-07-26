extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal atkStart
signal atkOver

# 基本数据
var data = {
	"id" : 1,
	"img" : "res://atk/img/防.png",
	"speed" : 300,
}
# 游戏运行状态
var status = 1
# 攻击蓄力时间
var atkTime = 1
# 
func _ready():
	initData()

# 初始化
func initData():
	texture = load(data.img)
	rect_position.x = 950

func _physics_process(delta):
	if status == 1:
		var positionX = rect_position.x - data.speed * delta
		if positionX <= -50:
			atkStart()
		else:
			rect_position.x = positionX
	elif status == 2:
		pass
	elif status == 3 and atkTime <=0 :
		atkOver()
		rect_position.x = 950
	elif status == 3 and atkTime >0 :
		atkTime -= delta

# 暂停游戏
func pauseGame(status):
	if status == -1:
		return
	self.status = status

func die():
	print("死了")
	status = -1
	modulate = Color(1, 1, 1, 0.2)

# 攻击蓄力完成
func atkOver():
	emit_signal("atkOver",data.id,self)
#	status = 1

# 攻击蓄力开始
func atkStart():
	emit_signal("atkStart",data.id,self)

# 设置攻击蓄力时间
func setAtkTime(time):
	atkTime = time
	status = 3

# 设置数据
func setData(data):
	self.data = data

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
