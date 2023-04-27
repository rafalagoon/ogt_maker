extends Control

var recto_counter = 0
var toilet_pressed = false

var ogt_colors = []


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Globals.new_ogt:
		open_ogt()
	else:
		create_clean_ogt()

	
	create_toilet()
	
	
	
func create_toilet ():
	get_node("%GridContainer").columns = Globals.ogt_width
#	
	var ogt_size = Vector2(Globals.ogt_width, Globals.ogt_height)
	
	var recto_size = $Toilet.rect_size / ogt_size
	
	recto_size = Vector2(floor(recto_size.x), floor(recto_size.y))
	
	get_node("%GridContainer").rect_min_size = recto_size * ogt_size
	
	for j in Globals.ogt_height:
		for i in Globals.ogt_width:
			var recto = ColorRect.new()
			
			recto.rect_min_size = $Toilet.rect_size / ogt_size
			
			recto.color = ogt_colors[recto_counter]

			recto.name = "recto"+str(recto_counter)
			
			recto_counter += 1

			get_node("%GridContainer").add_child(recto)
			
			recto.mouse_filter = ColorRect.MOUSE_FILTER_IGNORE


func create_clean_ogt ():
	for j in Globals.ogt_width*Globals.ogt_height:
		ogt_colors.append(Color.black)
			
	return ogt_colors


func open_ogt ():
	var file = File.new()
	file.open(Globals.ogt_file, File.READ)
	
	var header = file.get_line().split(";")
	
	if header[0] != "OGT":
		print("Error, esto no es un OGT")
		
		return false
		
	if header[1] != "v0.5":
		print("Es una versión no soportada")
		
	Globals.ogt_width = int(header[2])
	Globals.ogt_height = int(header[3])
	
	for j in range(0, Globals.ogt_height):
		var colors = file.get_line().split(";")
		for i in range(0, Globals.ogt_width):
			ogt_colors.append(colors[i])

	return ogt_colors


func _on_Toilet_gui_input(event):
	if event is InputEventMouseButton:
		toilet_pressed = event.pressed

	if not toilet_pressed:
		return
		
	for recto in get_node("%GridContainer").get_children():
		if Rect2(recto.rect_global_position, recto.rect_size).has_point(event.global_position):
			recto.color = $ColorPicker.color


func _on_CleanButton_pressed():
	for recto in get_node("%GridContainer").get_children():
		recto.color = Color.black


func _on_FlushButton_pressed():
	var colors = []
	for i in range(0, get_node("%GridContainer").get_child_count()):
		colors.append("#"+get_node("%GridContainer/recto"+str(i)).color.to_html(false))
		
		
	var file = File.new()
	file.open(Globals.ogt_file, File.WRITE)


	var header = "OGT;v0.5;"+str(Globals.ogt_width)+";"+str(Globals.ogt_height)+";;"

	file.store_line(header);

	var ogt_line = ""
	var color_counter = 0
	for color in colors:
		ogt_line += color+";"
		color_counter += 1
		if color_counter % Globals.ogt_width == 0:
			file.store_line(ogt_line+";")
			
			ogt_line = ""

	file.close()


















