extends Panel

# class member variables go here, for example:
var menu_on = false
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)

func _on_versus_pressed():
		get_node("/root/global").goto_scene("res://scenes/pong.tscn")
		#get_tree().change_scene("res://scenes/pong.tscn")

func _on_quit_pressed():
		get_tree().quit()

func _on_test_button_pressed():
		get_node("menu").show()

func _process(delta):
	if(Input.is_action_pressed("ui_accept")) and menu_on == false:
		get_node("menu").show()
	
