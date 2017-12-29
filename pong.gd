extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screen_size
var pad_size
var initial_direction = 1
var direction = Vector2(-1.0, 0.0)
var pause_off = true


# Constant for ball speed (in pixels/second)
const INITIAL_BALL_SPEED = 240
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 250

var left_point_count = 0
var right_point_count = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)
	set_process_input(true)
	
	# set counting points to "zero"
	get_node("left_point_count").set_text(str(left_point_count))
	get_node("right_point_count").set_text(str(right_point_count))

func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
	var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
	
	# Integrate new ball position
	ball_pos += direction * ball_speed * delta
	
	# Flip when touching roof or floor
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	# Flip, change direction and increase speed when touching pads
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		get_node("SamplePlayer").play("boing")
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
	# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		# update right_point_count
		if (ball_pos.x < 0):
			get_node("SamplePlayer").play("coin")
			right_point_count += 1
			get_node("right_point_count").set_text(str(right_point_count))
			initial_direction = 1
		if (ball_pos.x > screen_size.x):
			get_node("SamplePlayer").play("coin")
			left_point_count += 1
			get_node("left_point_count").set_text(str(left_point_count))
			initial_direction = 0
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		if (initial_direction == 1):
			direction = Vector2(1, 0)
		else:
			direction = Vector2(-1, 0)
			
	get_node("ball").set_pos(ball_pos)
	
	var left_pos = get_node("left").get_pos()

	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	
	get_node("left").set_pos(left_pos)
	
	# Move right pad
	var right_pos = get_node("right").get_pos()
	
	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta
	
	get_node("right").set_pos(right_pos)
	
	



func _input(event):
	if(event.is_action("pad_start") == true) or (event.is_action("ui_accept") == true) and pause_off == true:
		get_tree().set_pause(true)
		get_node("pause_menu").show()
		pause_off = false
		
	# not working due to fact that in "set_pause(true)" _input process is frozen - dont know how to fix it
	if(event.is_action("ui_cancel") == true) and pause_off == false:
		print("worked")
		get_tree().set_pause(false)
		get_node("pause_menu").hide()
		pause_off = true

func _on_pause_off_pressed():
	get_tree().set_pause(false)
	get_node("pause_menu").hide()
	pause_off = true
