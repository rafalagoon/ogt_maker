extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OpenOGTButton_pressed():
	$OGTDialog.visible = true
	
#	get_tree().change_scene("res://scenes/Main.tscn")


func _on_NewOGTButton_pressed():
	var ogt_file = $FileName.text.strip_edges(true, true)
	if ogt_file == "":
		$FileName.grab_focus()
		return
		
	if ogt_file.get_extension() != "ogt":
		ogt_file += ".ogt"
		
	var ogt_width = int($OGTSizeW.text.strip_edges(true, true))
	if ogt_width <= 0:
		$OGTSizeW.grab_focus()
		return
		
	var ogt_height = int($OGTSizeH.text.strip_edges(true, true))
	if ogt_height <= 0:
		$OGTSizeH.grab_focus()
		return
		
	Globals.new_ogt = true
	Globals.ogt_file = ogt_file
	Globals.ogt_width = ogt_width
	Globals.ogt_height = ogt_height
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_OGTDialog_file_selected(path):
	Globals.ogt_file = path
	
	get_tree().change_scene("res://scenes/Main.tscn")
