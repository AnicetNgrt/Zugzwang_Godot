tool
extends HTTPRequest

export(String, 'GET','POST','PUT','DELETE') var type = 'GET' setget _set_type
func _set_type(value):
	type = value
	match(type):
		'GET': _true_type = 0
		'POST': _true_type = 2
		'PUT': _true_type = 3
		'DELETE': _true_type = 4
export(String) var route = '/'

var _true_type = 0

func send(request_dict):
	var http = HTTPClient.new()
	var query_string = http.query_string_from_dict(request_dict)
	var headers = ["Content-Type: application/x-www-form-urlencoded", "Content-Length: " + str(query_string.length())]
	var params = {}
	if ApiConfig.api_password.length() > 0: params["password"] = ApiConfig.api_password
	var params_string = http.query_string_from_dict(params)
	var url = ApiConfig.api_url+route
	if params_string.length() > 0:
		url += '?'+params_string
	request(url,headers,true,_true_type,query_string)
