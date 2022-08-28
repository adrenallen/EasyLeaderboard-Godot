extends Node2D

signal close_button_pressed

const AES_SCENE = preload("res://leaderboard/AES.gd")

const LEADERBOARD_URL = "https://lb.userdefined.io"
const PAGE_SIZE = 10

#const LEADERBOARD_URL = "http://172.19.38.67:6969"

var lb_row_scene = preload("res://leaderboard/LeaderboardRow.tscn")

export var show_submit_score = false
export var submit_score_value = 0
export var submit_score_name = ""
export var submit_score_meta = {}
export var game_name = "ld50"
export var show_new_game_button = true
export var leaderboard_asc = false
export var show_close_button = false
export var close_button_deletes = false
# Called when the node enters the scene tree for the first time.

var _validation = null

var lb_results = null
var current_page = 0

func _ready():
	_refresh_leaderboard()
	$CanvasLayer/Leaderboard/CloseButton.visible = show_close_button
	$CanvasLayer/ScoreSubmitModal.visible = show_submit_score
	$CanvasLayer/ScoreSubmitModal/Panel/ScoreLabel/ScoreValue.text = str(submit_score_value)
	
	$CanvasLayer/Leaderboard/NewGameButton.visible = show_new_game_button
	
	if show_submit_score:
		$CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.grab_focus()
			
	$CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.text = str(submit_score_name)
	
	if submit_score_meta.has("events"):
		var validation_builder = str(submit_score_meta["events"][0]["e"]["v"])
		if len(submit_score_meta["events"]) > 4:
			validation_builder += JSON.print(submit_score_meta["events"][3])
			validation_builder += JSON.print(submit_score_meta["events"][-2])
			
		validation_builder += str(submit_score_value)
		
		if len(submit_score_meta["events"]) > 8:
			validation_builder += JSON.print(submit_score_meta["events"][7])
			validation_builder += JSON.print(submit_score_meta["events"][-4])
			
		validation_builder += JSON.print(submit_score_meta["events"][-1])
		
		_validation = validation_builder.sha256_text()
		

func _process(delta):
	pass

func _refresh_leaderboard():
	$GetLeaderboardRequest.request(LEADERBOARD_URL + "/games/" + game_name + "?asc=" + str(leaderboard_asc).to_lower() + "&limit=10", PoolStringArray(), false, HTTPClient.METHOD_GET)

func _on_SubmitScoreButton_pressed():
	$CanvasLayer/ScoreSubmitModal/Panel/SubmitScoreButton.visible = false
	var request = { name = submit_score_name,
		score = submit_score_value,
		game = game_name,
		metaData = JSON.print(submit_score_meta) }
	
	request["validation"] = _validation
	
	var headers = PoolStringArray()
	headers.append("Content-Type: application/json")
	$SubmitLeaderboardScore.request(LEADERBOARD_URL + "/games/submit", headers, false, HTTPClient.METHOD_POST, JSON.print(request))

	

func _on_GetLeaderboardRequest_request_completed(result, response_code, headers, body):
	
	_clear_leaderboard()
	var json = JSON.parse(body.get_string_from_utf8())
	if not json or not json.result:
		return #fail silent it's just a jam series game >:(
	lb_results = json.result
	current_page = 0
	_update_lb()
	
	
		
func _update_lb():
	_clear_leaderboard()
	if !lb_results:
		return
		
	var pos = PAGE_SIZE * current_page
	var max_pos = PAGE_SIZE + (PAGE_SIZE*current_page)
	print(max_pos)
	if max_pos >= len(lb_results):
		max_pos = len(lb_results)-1
	
	for i in range(pos, max_pos):
		var item = lb_results[i]
#	for item in lb_results:
#		if pos >= PAGE_SIZE + (PAGE_SIZE*current_page):
#			break
		
		$CanvasLayer/Leaderboard/Panel/Top10Grid.add_child(_new_leaderboard_cell(str(pos+1), item))
		pos += 1
	_update_page_buttons()

func _clear_leaderboard():
	for child in $CanvasLayer/Leaderboard/Panel/Top10Grid.get_children():
		$CanvasLayer/Leaderboard/Panel/Top10Grid.remove_child(child)
	
func _new_leaderboard_cell(pos, entry):
	
	var lbc = lb_row_scene.instance()
	lbc.username = entry.name
	lbc.score = entry.score
	lbc.position = pos
	
	var json = JSON.parse(entry.metaData)
	if json.result:
		var metadata = {}
		if typeof(json.result) == TYPE_DICTIONARY:
			metadata = json.result as Dictionary
			lbc.world_name = metadata["world_name"]
			lbc.world_seed = metadata["world_seed"]
	
	return lbc

func _on_SubmitLeaderboardScore_request_completed(result, response_code, headers, body):
	_refresh_leaderboard()
	$CanvasLayer/ScoreSubmitModal.visible = false

func _on_NameValue_text_changed():
	var input_name = $CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.text
	
	# fix new lines being replaced!
	var regex = RegEx.new()
	regex.compile("\n")
	var input_nl_replaced = regex.sub(input_name, "", true)
	if input_nl_replaced != input_name:
		$CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.text = input_nl_replaced
		input_name = input_nl_replaced
	
	if len(input_name) > 32:
		$CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.text = input_name.substr(0, 32)
	submit_score_name = $CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.text
	$CanvasLayer/ScoreSubmitModal/Panel/SubmitScoreButton.disabled = len(submit_score_name) < 3


func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Game.tscn")


func _on_CloseScoreSubmitButton_pressed():
	$CanvasLayer/ScoreSubmitModal.visible = false


func _on_CloseButton_pressed():
	emit_signal("close_button_pressed")
	if close_button_deletes:
		queue_free()


func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_TouchScreenNameInputButton_pressed():
	$CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.text = JavaScript.eval("prompt('Enter your name for your score!')")
	$CanvasLayer/ScoreSubmitModal/Panel/NameLabel/NameValue.release_focus()
	_on_NameValue_text_changed()


func _on_NameValue_gui_input(event):
	if event.is_action("enter_key") && not $CanvasLayer/ScoreSubmitModal/Panel/SubmitScoreButton.disabled:
		_on_SubmitScoreButton_pressed()

func _update_page_buttons():
	if current_page <= 0:
		$CanvasLayer/Leaderboard/Panel/Top10Label/PrevPageButton2.visible = false
	else:
		$CanvasLayer/Leaderboard/Panel/Top10Label/PrevPageButton2.visible = true
		
	if (current_page*PAGE_SIZE) + PAGE_SIZE > len(lb_results):
		$CanvasLayer/Leaderboard/Panel/Top10Label/NextPageButton.visible = false
	else:
		$CanvasLayer/Leaderboard/Panel/Top10Label/NextPageButton.visible = true
		
func _on_NextPageButton_pressed():
	current_page += 1
	_update_lb()

func _on_PrevPageButton2_pressed():
	current_page -= 1
	_update_lb()
