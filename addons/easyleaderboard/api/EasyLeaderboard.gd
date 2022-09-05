class_name EasyLeaderboard
extends Node

signal leaderboard_results_changed(results)
signal leaderboard_score_submitted(result)

const DEFAULT_EASY_LEADERBOARD_URL = "https://lb.userdefined.io"
const DEFAULT_GAME_NAME = "easy-leaderboard-example"
const DEFAULT_SORT_RESULTS_ASCENDING = false

@export var easy_leaderboard_url  : String = DEFAULT_EASY_LEADERBOARD_URL
@export var game_name : String = DEFAULT_GAME_NAME
@export var sort_results_ascending : bool = DEFAULT_SORT_RESULTS_ASCENDING

@export var page_size : int = 10
@export var current_page : int = 1

@onready var get_leaderboard_request : HTTPRequest = HTTPRequest.new()
@onready var submit_score_request : HTTPRequest = HTTPRequest.new()


func _ready():
	get_leaderboard_request.request_completed.connect(_on_get_leaderboard_request_request_completed)
	submit_score_request.request_completed.connect(_on_submit_score_request_request_completed)
	add_child(get_leaderboard_request)
	add_child(submit_score_request)
	
# Initiates request to get leaderboard results
# retrieve the results by connecting to the `leaderboard_results_changed` signal
func get_leaderboard_results():
	_refresh_leaderboard()

# Submit a score to the leaderboard
# emits the `leaderboard_score_submitted` signal when complete
func submit_leaderboard_score(score_name, score_value, score_metadata = null, score_validation = null):
	_submit_leaderboard_score(score_name, score_value, score_metadata, score_validation)
	
func _refresh_leaderboard():
	
	# Build the query params
	var params : String = "?"
	params += "asc=" + str(sort_results_ascending).to_lower()
	params += "&pagesize=" + str(page_size)
	params += "&page=" + str(current_page)
	
	# TODO - Build the URL more nicely
	get_leaderboard_request.request(
		easy_leaderboard_url + "/games/" + game_name + params,
		[],
		false,
		HTTPClient.METHOD_GET
	)


func _on_get_leaderboard_request_request_completed(_result, response_code, _headers, body):

	var response_body = body.get_string_from_utf8()
	
	# TODO - handle a non-successful response code!
	if response_code != 200:
		push_error("Error in leaderboard results HTTP response. Got code ", response_code, " and body ", response_body)
		return
	
	var json = JSON.new()
	var error = json.parse(response_body)
	if error == OK:
		leaderboard_results_changed.emit(json.get_data())
	else:
		# TODO - handle json error!
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", response_body, " at line ", json.get_error_line())


func _submit_leaderboard_score(score_name, score_value, score_metadata = {}, score_validation = null):
	var json = JSON.new()
	var request = { name = score_name,
		score = score_value,
		game = game_name,
		metaData = json.stringify(score_metadata)}
		
	# Validation is not _required_ so only send along if 
	# we have a value to send
	if score_validation:
		request["validation"] = score_validation
	else:
		request["validation"] = json.stringify(request).sha256_text()

	submit_score_request.request(easy_leaderboard_url + "/games/submit", ['Content-Type: application/json'], false, HTTPClient.METHOD_POST, json.stringify(request))


func _on_submit_score_request_request_completed(_result, response_code, _headers, body):
	
	var response_body = body.get_string_from_utf8()
	
	# TODO - handle a non-successful response code!
	if response_code != 200:
		push_error("Error in submit score HTTP response. Got code ", response_code, " and body ", body.get_string_from_utf8())
		return
	
	var json = JSON.new()
	var error = json.parse(response_body)
	if error == OK:
		leaderboard_score_submitted.emit(json.get_data())
	else:
		# TODO - handle json error!
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", response_body, " at line ", json.get_error_line())
		
