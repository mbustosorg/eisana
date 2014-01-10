note
    description: "[
                  http://developers.asana.com/documentation/#Errors
]"
	date: "$Date: $"
	revision: "$Revision: $"
	
class
	ASANA_ERROR

create
	make_empty,
	make_from_string,
	make_success

feature {NONE} -- Creation

	make_from_string (status_code: INTEGER; error_body: STRING)
			-- Create the error from `status_code' and `error_body'
		local
			parser: JSON_PARSER
			i: INTEGER
		do
			make_empty
			create parser.make_parser (error_body)
			if parser.is_parsed and attached parser.parse_object as j_o then
				json := j_o
			end
			status := status_code
			if attached {JSON_ARRAY} json.item (create {JSON_STRING}.make_json ("errors")) as errors_objects then
				from
					i := 1
				until
					i > errors_objects.count
				loop
					if attached {JSON_OBJECT} errors_objects[i] as error_object then
						if attached {JSON_STRING} error_object.item ("message") as json_string then
							message := json_string.item
						end
						if status = 500 then
							if attached {JSON_STRING} error_object.item ("phrase") as json_string then
								phrase := json_string.item
							end
						end
					end
					i := i + 1
				end
			end
		end

	make_success
			-- Create the success error object
		do
			make_empty
			status := 200
		end
	
	make_empty
			-- Create the empty error object
		do
			message := ""
			phrase := ""
			create json.make
		end
	
feature -- Query

	is_success: BOOLEAN
			-- Is this a successful action?
		do
			Result := status > 0 and status < 300
		end
	
feature -- Access

	message: STRING
	phrase: STRING

	status: INTEGER
	
	documentation: STRING = "[
200	Success. If data was requested, it will be available in the data field at the top level of the response body.
201	Success (for object creation). Its information is available in the data field at the top level of the response body. The API URL where the object can be retrieved is also returned in the Location header of the response.
400	Invalid request. This usually occurs because of a missing or malformed parameter. Check the documentation and the syntax of your request and try again.
401	No authorization. A valid API key was not provided with the request, so the API could not associate a user with the request.
403	Forbidden. The API key and request syntax was valid but the server is refusing to complete the request. This can happen if you try to read or write to objects or properties that the user does not have access to.
404	Not found. Either the request method and path supplied do not specify a known action in the API, or the object specified by the request does not exist.
429	Rate Limit Enforced. Asana imposes a limit on the rate at which users can make requests. The limit is currently around 100 requests per minute, but this is not guaranteed: it may vary with server load, and we may change it in the future. The Retry-After response header will specify the number of seconds until the user can make another request. Clients sending large bursts of requests should handle this error code to retry after the delay. 

Rate limits are important to prevent abuse and keep the service available to everyone. If you definitely need a higher rate limit for your application, please contact developer support and we will look into granting an exception.
500	Server error. There was a problem on Asana's end.
]"

feature {NONE} -- Implementation

 	json: JSON_OBJECT
	
end

