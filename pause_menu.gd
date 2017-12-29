extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process_input(true)

func _input(event):
	if(event.is_action("pad_start") == true) or (event.is_action("ui_accept") == true) and pause_off == true:
		print("worked")
		get_tree().set_pause(true)
		get_node("pause_menu").show()
		pause_off = false

	if(event.is_action("ui_cancel") == true) and pause_off == false:
		print("worked")
		get_tree().set_pause(false)
		get_node("pause_menu").hide()
		pause_off = true

func _on_pause_off_pressed():
	get_tree().set_pause(false)
	get_node("pause_menu").hide()
	#pause_off = true
