note
    description: "[
                  Main API object for ASANA
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA

create
	make

feature {NONE} -- Implementation

	make (a_api_key: like api_key)
			-- Create the API session
		do
			api_key := a_api_key
--			create last_error.make_empty
		end

feature -- Access

	api_key: READABLE_STRING_8

	last_error: detachable ASANA_ERROR
			-- Status of the last API call

	is_success: BOOLEAN
			-- Last operation succeed without any error?
		do
			Result := last_error = Void
		end

feature -- Basic operations

	reset_error
			-- Reset `last_error'.
		do
			last_error := Void
		end

	new_task (task: ASANA_TASK): ASANA_TASK
			-- Create a task using the `task' specification
		local
			json_post: STRING
			resp: HTTP_CLIENT_RESPONSE
			parser: JSON_PARSER
		do
			reset_error
			json_post := "{ %"data%": {%"workspace%":" + task.workspace.id.out + ","
			json_post.append ("%"name%":%"" + task.name + "%",")
			json_post.append ("%"assignee%":" + task.assignee.id.out + "}}")
			resp := session.post ("/tasks", request_context, json_post)
			set_last_error (resp)
			create Result.make_empty
			if is_success and then attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as task_object then
						create Result.make_from_json (task_object)
					end
				end
			end
		end

	delete_task (task: ASANA_TASK)
			-- Delete a task using the `task' specification
		require
			has_id: task.id > 0
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			resp := session.delete ("/tasks/" + task.id.out, request_context)
			set_last_error (resp)
		end

	new_tag (name: STRING; workspace: ASANA_WORKSPACE): ASANA_TAG
			-- Create a tag usign the specification
		local
			json_post: STRING
			resp: HTTP_CLIENT_RESPONSE
			parser: JSON_PARSER
		do
			reset_error
			json_post := "{ %"data%": {%"workspace%":" + workspace.id.out + ","
			json_post.append ("%"name%":%"" + name + "%"}}")
			resp := session.post ("/tags", request_context, json_post)
			set_last_error (resp)
			create Result.make_empty
			if is_success and then attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as tag_object then
						create Result.make_from_json (tag_object)
					end
				end
			end
		end

	assign_tag (tag: ASANA_TAG; task: ASANA_TASK)
			-- Assign tag `tag' to `task'
		require
			valid_tag_id: tag.id > 0
			valid_task_id: task.id > 0
		local
			json_post: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			json_post := "{ %"data%": {%"tag%":" + tag.id.out + "}}"
			resp := session.post ("/tasks/" + task.id.out + "/addTag", request_context, json_post)
			set_last_error (resp)
		end

	remove_tag (tag: ASANA_TAG; task: ASANA_TASK)
			-- Remove tag `tag' from `task'
		require
			valid_tag_id: tag.id > 0
			valid_task_id: task.id > 0
		local
			json_post: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			json_post := "{ %"data%": {%"tag%":" + tag.id.out + "}}"
			resp := session.post ("/tasks/" + task.id.out + "/removeTag", request_context, json_post)
			set_last_error (resp)
		end

	new_project (project: ASANA_PROJECT): ASANA_PROJECT
			-- Create a new project using the `project' specification
		local
			json_post: STRING
			resp: HTTP_CLIENT_RESPONSE
			parser: JSON_PARSER
		do
			reset_error
			json_post := "{ %"data%": {%"workspace%":" + project.workspace.id.out + ","
			json_post.append ("%"name%":%"" + project.name + "%",")
			json_post.append ("%"notes%":%"" + project.notes + "%"}}")
			resp := session.post ("/tags", request_context, json_post)
			set_last_error (resp)
			create Result.make_empty
			if is_success and then attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as project_object then
						create Result.make_from_json (project_object)
					end
				end
			end
		end

	delete_project (project: ASANA_PROJECT)
			-- Delete the project matching the `project' specification
		require
			valid_id: project.id > 0
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			resp := session.delete ("/projects/" + project.id.out, request_context)
			set_last_error (resp)
		end

feature -- Query

	task_by_id (id: INTEGER): ASANA_TASK
			-- Task object for `id'
		do
			create Result.make_empty
		end

	tasks (workspace: ASANA_WORKSPACE; assignee: ASANA_USER): ARRAY [ASANA_TASK]
			-- Collection of tasks for `assignee' in `workspace'
		local
			resp: HTTP_CLIENT_RESPONSE
			parser: JSON_PARSER
			task: ASANA_TASK
		do
			reset_error
			resp := session.get ("/tasks?workspace=" + workspace.id.out + "&assignee=" + assignee.query_name, request_context)
			set_last_error (resp)
			create Result.make_empty
			if attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_ARRAY} j_o.item (create {JSON_STRING}.make_json ("data")) as task_objects then
						across (1 |..| task_objects.count) as i
		                loop
							if attached {JSON_OBJECT} task_objects[i.item] as task_object then
								create task.make_from_json (task_object)
								Result.force (task, Result.count + 1)
							end
					    end
					end
				end
			end
		end

	tasks_by_user (user_for_tasks: ASANA_USER): ARRAY [ASANA_TASK]
			-- Collection of tasks for `user_for_tasks' across all of users' workspaces
		local
			task_list: ARRAY [ASANA_TASK]
			i: INTEGER
		do
			create Result.make_empty
			across user_for_tasks.workspaces as workspace
	        loop
				if is_success then
					task_list := tasks (workspace.item, user_for_tasks)
					from
						i := 1
					until
						i > task_list.count
					loop
						Result.force (task_list[i], Result.count + 1)
						i := i + 1
					end
				end
		    end
		end

	user_from_id (id: INTEGER): ASANA_USER
			-- User object for `id'
		require
			valid_id: id >= 0
		local
			resp: HTTP_CLIENT_RESPONSE
			parser: JSON_PARSER
		do
			reset_error
			if id = 0 then
				resp := session.get ("/users/me", request_context)
			else
				resp := session.get ("/users/" + id.out, request_context)
			end
			set_last_error (resp)
			create Result.make_empty
			if attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as user_object then
						create Result.make_from_json (user_object)
					end
				end
			end
		end

	users: ARRAY [ASANA_USER]
			-- Collection of users in this application
		local
			resp: HTTP_CLIENT_RESPONSE
			user: ASANA_USER
			parser: JSON_PARSER
			i: INTEGER
		do
			reset_error
			resp := session.get ("/users?opt_fields=name,email,workspaces", request_context)
			set_last_error (resp)
			create Result.make_empty
			if attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_ARRAY} j_o.item (create {JSON_STRING}.make_json ("data")) as user_objects then
						from
							i := 1
						until
							i > user_objects.count
						loop
							if attached {JSON_OBJECT} user_objects[i] as user_object then
								create user.make_from_json (user_object)
								Result.force (user, Result.count + 1)
								print (user.debug_output + "%N")
								user.workspaces.do_all (agent (ws: ASANA_WORKSPACE)
		                                                  do
															  print (ws.debug_output + "%N")
														  end)
							end
							i := i + 1
						end
					end
				end
			end
		end

	tasks_with_tag (tag: ASANA_TAG): ARRAY [ASANA_TASK]
			-- Collection of tasks with tag `tag'.
			-- Resulting tasks are not complete and should be queried for
			-- full task record.
		require
			has_id: tag.id > 0
		local
			resp: HTTP_CLIENT_RESPONSE
			parser: JSON_PARSER
			task: ASANA_TASK
			i: INTEGER
		do
			reset_error
			resp := session.get ("/tags/" + tag.id.out + "/tasks", request_context)
			set_last_error (resp)
			create Result.make_empty
			if is_success and then attached resp.body as body then
				create parser.make_parser (body)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_ARRAY} j_o.item (create {JSON_STRING}.make_json ("data")) as task_objects then
						from
							i := 1
						until
							i > task_objects.count
						loop
							if attached {JSON_OBJECT} task_objects[i] as task_object then
								create task.make_from_json (task_object)
								Result.force (task, Result.count + 1)
							end
							i := i + 1
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	set_last_error (resp: HTTP_CLIENT_RESPONSE)
			-- Set the `last_error' status using `resp'
		do
			if resp.status > 299 or resp.status = 0 then
				if attached resp.body as resp_body then
					create last_error.make_from_string (resp.status, resp_body)
				else
					create last_error.make_from_string (0, "UNKNOWN ERROR")
				end
--			else
--				create last_error.make_success
			end
		end

	session: HTTP_CLIENT_SESSION
			-- HTTP Session for the API application
		local
			h: LIBCURL_HTTP_CLIENT
		once
			create h.make
			Result := h.new_session ("https://app.asana.com/api/1.0")
			Result.set_credentials (api_key, "")
			Result.set_basic_auth_type
			Result.set_is_insecure (True)
		end

	request_context: HTTP_CLIENT_REQUEST_CONTEXT
			-- Request context for the API application
		once
			create Result.make
			Result.headers.put ("application/json", "Content-Type")
			Result.set_credentials_required (True)
		end

end



