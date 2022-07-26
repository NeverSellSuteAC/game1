extends KinematicBody2D

onready var tween = $Tween
onready var atkLeble = load("res://InformationPanel/atkLable.tscn")
var speed = Config.mo_fox_default_speed
var atk = Config.mo_fox_default_atk
var level = Config.mo_fox_default_level
var health = Config.mo_fox_default_health
var armor = Config.mo_fox_default_armor
var magic = Config.mo_fox_default_magic

var exp_num = 20

var atk_target
var atk_open = false
var atk_body_time = 0
var atk_body_interval_time = 2

var velocity = Vector2.ZERO

export var game_type = "fox"

var root
func _ready():
	root = get_tree().current_scene.get_node("run")
	$AnimationPlayer.play("新建动画")
	

func _process(delta):
	atk_body_time += delta
	if atk_target != null:
		move_func(delta)
	if atk_open:
		atk_func(delta)


#自动移动
func move_func(delta):
	# 调整面向
	$Sprite.flip_h = position.x > atk_target.position.x
	# 移动
	var direction = (atk_target.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * speed, delta * speed)
	move_and_slide(velocity)


#自动攻击
func atk_func(delta):
	if magic > 5:
		print("make_magic")
	if (atk_body_time >= atk_body_interval_time) and is_player_near():
		#近距离攻击
		pass
	
#设置面向目标
func set_face_player(player):
	atk_target = player


func is_player_near():
	return (abs(position.x - atk_target.position.x) < 100) and (abs(position.y - atk_target.position.y) < 100)

#碰撞攻击
func _on_Area2D_area_entered(area):
#	print(abs(position.x - atk_target.position.x) )
#	print(abs(position.y - atk_target.position.y) )
	if area.game_type == "player" and (atk_body_time >= atk_body_interval_time) and is_player_near():
		area.on_Attacked(atk)
		atk_body_time = 0


func on_Attacked(atk):
	# 显示攻击信息
	var lebleObj = atkLeble.instance()
	lebleObj.setText(atk)
	lebleObj.position = position
	lebleObj.position.x += 10
	root.add_child(lebleObj)
	# 计算攻击数据
	self.health -= atk
	if self.health <= 0:
		# 死亡确定
		on_died()


func on_died():
	# 经验值计算
	PlayerData.exp_now += exp_num
	# 经验值更新通知
	get_tree().current_scene.emit_signal("exp_update", PlayerData.exp_now)
	# 清目标除
	queue_free()
	get_tree().current_scene.mo_number -= 1
