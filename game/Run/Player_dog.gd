extends Node2D



var screen_size
var player_speed = PlayerData.player_speed
var player_atk_time = PlayerData.player_atk_time
var player_atk = PlayerData.player_atk
var level = PlayerData.level
var player_exp = 0
var health_max = PlayerData.base["生命"]
var base = {}
onready var animationTree = $AnimationTree
onready var animationTreeState = animationTree.get("parameters/playback")

onready var atkBox = load("res://Run/atkBox/AtkBox.tscn")

export var game_type = "player"

var root

func _ready():
	root = get_tree().current_scene.get_node("run")
	screen_size = get_viewport_rect().size

var rangeTime = 0
var atkAnimationTime = 0


func _process(delta):
	if rangeTime > 1000:
		rangeTime = player_atk_time
	if atkAnimationTime < -1000:
		atkAnimationTime = 0
	rangeTime += delta
	atkAnimationTime -= delta
	# 攻击
	# 攻击间隔
	if rangeTime >= player_atk_time and MouseClick() and PlayerData.moveTemp == null:
		atk()
		rangeTime = 0
	# 移动
	move(delta)


func move(delta):
	# 移动
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized()
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
#		$AnimationTree.set("parameters/Roll/blend_position", velocity)
		$AnimationTree.set("parameters/Run/blend_position", velocity)
		if atkAnimationTime < 0:
			animationTreeState.travel("Run")
		velocity = velocity * player_speed
	else:
		if atkAnimationTime < 0:
			animationTreeState.travel("Idle")
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func atk():
	# 创建攻击模型
	var atkObj = createAtkObj()
	# 执行攻击动画
	var velocity = (get_global_mouse_position() - position).normalized()
	$AnimationTree.set("parameters/atk/blend_position", velocity)
	animationTreeState.travel("atk")
	atkAnimationTime = 0.4
	
	# 攻击模型创
func createAtkObj():
	var atkObj = atkBox.instance()
	atkObj.position = position
	root.add_child(atkObj)
	# 移动攻击模型
	atkObj.setDirection(get_global_mouse_position())
	atkObj.atk = player_atk
	return atkObj

# 鼠标事件判断
func MouseClick():
	return Input.is_action_pressed("mouse_click")


func on_Attacked(atk):
	pass

func updatePlayerData(newData):
	for key in newData:
		self[key] = newData[key]
		if key == "player_exp" and player_exp >= PlayerData.exp_max:
			# 升级判定
			levelUp(newData[key])
		if key == "base":
			# 升级判定
			updateBaseData()

func updateBaseData():
	for key in PlayerData.base:
		match key:
			"攻击":
				player_atk = PlayerData.base[key]
			"生命":
				health_max = PlayerData.base[key]
				get_tree().current_scene.emit_signal("health_max_update")
		pass
	pass

func levelUp(new_exp):
	# 等级连升判断
	# 属性增加
	player_atk += (level + 1) 
	PlayerData.base["攻击"] = player_atk
	level += 1
	# 经验重置
	player_exp = 0
	# 属性保存
	PlayerData.exp_now = player_exp
	PlayerData.exp_max += level * 20
	PlayerData.level = level
	# 经验值更新通知/经验值最大值更新通知
	get_tree().current_scene.emit_signal("exp_max_update")
	# 等级更新通知
	get_tree().current_scene.emit_signal("level_update", PlayerData.level)
	
	
	
	
	
	
