extends TabContainer

var NounPath = "res://assets/NounCategories/"
var NounStrings = {}
#region NounToggles
@onready
var AnimalToggle
@onready
var BodypartToggle
@onready
var CreatureToggle
@onready
var FoodToggle
@onready
var FurnitureToggle
@onready
var ObjectToggle
@onready
var PlaceToggle
@onready
var PlantToggle
@onready
var ProfessionToggle
@onready
var ToolToggle
@onready
var VehicleToggle
@onready
var WeaponToggle
#endregion

var AdjectivePath = "res://assets/AdjectiveCategories/"
var AdjectiveStrings = {}
#region AdjectiveToggles
@onready
var AgeToggle
@onready
var ColorToggle
@onready
var FeatureToggle
@onready
var MaterialToggle
@onready
var QualityToggle
@onready
var TraitToggle
#endregion

@onready
var PromptOptions
@onready
var PromptDisplay = $"Text Prompt/ScrollingPrompt/PromptDisplay"

func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_MAXIMIZE_DISABLED, true)
	NounStrings = load_paths(NounPath)
	AdjectiveStrings = load_paths(AdjectivePath)
	#for key in NounStrings:
	#	PromptDisplay.text += key + "," + NounStrings[key] + "\n"

func _on_http_request_request_completed(result, response_code, headers, body):
		var image = Image.new()
		var error = image.load_png_from_buffer(body)
		if error != OK:
			var json = JSON.parse_string(body.get_string_from_utf8())
			var pages = json['query']['pages']
			for page_id in pages.keys():
				print(pages[page_id].original['source'])
				$"../HTTPRequest".request(pages[page_id].original['source'])
	
		#var img = Image.new()
		#img.load_png_from_buffer(body)
		#var img_texture: ImageTexture = ImageTexture.create_from_image(img)
		#$"Text Prompt/Placeholder Image".texture = img_texture
		
#https://en.wikipedia.org/wiki/Romanesco_broccoli

#var wikipedia_prefix = "https://en.wikipedia.org/wiki/"

#var search_endpoint = "https://" + lang + ".wikipedia.org/w/api.php?action=query&format=json&list=search&srprop=title&origin=*&srsearch="
#var random_endpoint = "https://" + lang + ".wikipedia.org/w/api.php?action=query&format=json&generator=random&grnnamespace=0&prop=info&origin=*"

func _process(_delta):
	PromptOptions = $"Text Prompt/PromptButtons/PromptOptions".get_selected_id() 
	#region NounToggles
	AnimalToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Animals".button_pressed
	BodypartToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Bodyparts".button_pressed
	CreatureToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Creatures".button_pressed
	FoodToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Foods".button_pressed
	FurnitureToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Furniture".button_pressed
	ObjectToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Objects".button_pressed
	PlaceToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Places".button_pressed
	PlantToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Plants".button_pressed
	ProfessionToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Professions".button_pressed
	ToolToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Tools".button_pressed
	VehicleToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Vehicles".button_pressed
	WeaponToggle = $"Text Prompt/NounStuff/NounScroll/NounList/Weapons".button_pressed 
	#endregion
	#region AdjectiveToggles
	if (PromptOptions >= 2) :
		AgeToggle = $"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Ages".button_pressed
		ColorToggle = $"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Colors".button_pressed
		FeatureToggle = $"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Features".button_pressed
		MaterialToggle = $"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Materials".button_pressed
		QualityToggle = $"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Qualities".button_pressed
		TraitToggle = $"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Traits".button_pressed
		# enable the adjective options
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Ages".disabled = false
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Colors".disabled = false
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Features".disabled = false
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Materials".disabled = false
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Qualities".disabled = false
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Traits".disabled = false
	else :
		# disable the adjective options
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Ages".disabled = true
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Colors".disabled = true
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Features".disabled = true
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Materials".disabled = true
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Qualities".disabled = true
		$"Text Prompt/AdjectiveStuff/AdjectiveScroll/AdjectiveList/Traits".disabled = true
	#endregion

func load_paths(dirPath):
	var pathDict = {}
	var dir = DirAccess.open(dirPath)
	dir.list_dir_begin()
	var current_path = dir.get_next()
	pathDict[current_path.left(-4)] = dirPath + current_path
	while true:
		current_path = dir.get_next()
		if (current_path == "") :
			break
		pathDict[current_path.left(-4)] = dirPath + current_path
	return pathDict

func load_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_csv_line()
	return content

func get_word(string):
	var word = string.get(randi() % string.size())
	return word

func _on_prompt_button_pressed():
	var holder;
	var wikipedia_prefix = "https://en.wikipedia.org/wiki/"
	var wikipedia_image_prefix = "http://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles="
	var nounString = PackedStringArray()
	#region NounToggles	
	if (AnimalToggle) :
		nounString += load_file(NounStrings["animals"])	
	if (BodypartToggle) :
		nounString += load_file(NounStrings["bodyparts"])	
	if (CreatureToggle) :
		nounString += load_file(NounStrings["creatures"])
	if (FoodToggle) :
		nounString += load_file(NounStrings["foods"])	
	if (FurnitureToggle) :
		nounString += load_file(NounStrings["furniture"])	
	if (ObjectToggle) :
		nounString += load_file(NounStrings["objects"])	
	if (PlaceToggle) :
		nounString += load_file(NounStrings["places"])	
	if (PlantToggle) :
		nounString += load_file(NounStrings["plants"])	
	if (ProfessionToggle) :
		nounString += load_file(NounStrings["professions"])	
	if (ToolToggle) :
		nounString += load_file(NounStrings["tools"])	
	if (VehicleToggle) :
		nounString += load_file(NounStrings["vehicles"])	
	if (WeaponToggle) :
		nounString += load_file(NounStrings["weapons"])	
	#endregion
	var adjectiveString = PackedStringArray()
	#region AdjectiveToggles
	if (PromptOptions >= 2) :
		if (AgeToggle) :
			adjectiveString += load_file(AdjectiveStrings["ages"])	
		if (ColorToggle) :
			adjectiveString += load_file(AdjectiveStrings["colors"])	
		if (FeatureToggle) :
			adjectiveString += load_file(AdjectiveStrings["features"]) 
		if (MaterialToggle) :
			adjectiveString += load_file(AdjectiveStrings["materials"])	
		if (QualityToggle) :
			adjectiveString += load_file(AdjectiveStrings["qualities"])	
		if (TraitToggle) :
			adjectiveString += load_file(AdjectiveStrings["traits"])	
	#endregion

	if ((PromptOptions == 1) && !nounString.is_empty()) :
		PromptDisplay.text += get_word(nounString) + "" + get_word(nounString) + "\n"
	elif (!nounString.is_empty() && !(PromptOptions >= 2) ):
		holder = get_word(nounString)
		PromptDisplay.text += holder + "\n"
		holder = holder.right(-1)
		$"../HTTPRequest".request(wikipedia_image_prefix + holder)
		$"Text Prompt/LinkButton".text = wikipedia_prefix + holder
		$"Text Prompt/LinkButton".uri = wikipedia_prefix + holder
	elif (nounString.is_empty()):
		PromptDisplay.text += " No Nouns Selected!\n"
	elif ((PromptOptions == 2) && !adjectiveString.is_empty() ) :
		PromptDisplay.text += get_word(adjectiveString) + "" + get_word(nounString) + "\n"
	elif ((PromptOptions == 3) && !adjectiveString.is_empty() ) :
		PromptDisplay.text += get_word(adjectiveString) + "" + get_word(nounString) + get_word(nounString) + "\n"
	elif ((PromptOptions == 4) && !adjectiveString.is_empty() ) :
		PromptDisplay.text += get_word(adjectiveString) + "," + get_word(adjectiveString) + "" + get_word(nounString) + "\n"
	elif ((PromptOptions >= 2) && adjectiveString.is_empty()) :
		PromptDisplay.text += " No Adjectives Selected!\n"
	else :
		PromptDisplay.text += " Error!\n"
		
		

func _on_clear_prompt_button_pressed():
	PromptDisplay.set_text("")
