note
    description: "[
                  Main API object for ASANA
				]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana", "src=http://developers.asana.com/documentation", "protocol=uri"

class
	ASANA

create
	make

feature {NONE} -- Implementation

	make (a_api_key: like api_key)
			-- Create the API session
		do
			api_key := a_api_key
			create {ASANA_JSON_FACTORY} factory
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
			post_data: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			post_data := "{ %"data%": {%"workspace%":" + task.workspace.id.out + ","
			post_data.append ("%"name%":%"" + task.name + "%",")
			post_data.append ("%"assignee%":" + task.assignee.id.out + "}}")
			resp := session.post ("/tasks", new_request_context, post_data)
			analyze_response (resp)
			if is_success then
				Result := factory.task_from_string (resp.body)
			else
				create Result.make_empty
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
			resp := session.delete ("/tasks/" + task.id.out, new_request_context)
			analyze_response (resp)
		end

	new_tag (name: STRING; workspace: ASANA_WORKSPACE): ASANA_TAG
			-- Create a tag usign the specification
		local
			post_data: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			post_data := "{ %"data%": {%"workspace%":" + workspace.id.out + ","
			post_data.append ("%"name%":%"" + name + "%"}}")
			resp := session.post ("/tags", new_request_context, post_data)
			analyze_response (resp)
			if is_success then
				Result := factory.tag_from_string (resp.body)
			else
				create Result.make_empty
			end
		end

	assign_tag (tag: ASANA_TAG; task: ASANA_TASK)
			-- Assign tag `tag' to `task'
		require
			valid_tag_id: tag.id > 0
			valid_task_id: task.id > 0
		local
			post_data: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			post_data := "{ %"data%": {%"tag%":" + tag.id.out + "}}"
			resp := session.post ("/tasks/" + task.id.out + "/addTag", new_request_context, post_data)
			analyze_response (resp)
		end

	remove_tag (tag: ASANA_TAG; task: ASANA_TASK)
			-- Remove tag `tag' from `task'
		require
			valid_tag_id: tag.id > 0
			valid_task_id: task.id > 0
		local
			post_data: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			post_data := "{ %"data%": {%"tag%":" + tag.id.out + "}}"
			resp := session.post ("/tasks/" + task.id.out + "/removeTag", new_request_context, post_data)
			analyze_response (resp)
		end

	new_project (project: ASANA_PROJECT): ASANA_PROJECT
			-- Create a new project using the `project' specification
		local
			post_data: STRING
			resp: HTTP_CLIENT_RESPONSE
		do
			reset_error
			post_data := "{ %"data%": {%"workspace%":" + project.workspace.id.out + ","
			post_data.append ("%"name%":%"" + project.name + "%",")
			post_data.append ("%"notes%":%"" + project.notes + "%"}}")
			resp := session.post ("/projects", new_request_context, post_data)
			analyze_response (resp)
			if is_success then
				Result := factory.project_from_string (resp.body)
			else
				create Result.make_empty
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
			resp := session.delete ("/projects/" + project.id.out, new_request_context)
			analyze_response (resp)
		end

feature -- Query

	task_by_id (id: INTEGER): ASANA_TASK
			-- Task object for `id'
		do
			create Result.make_empty
		end

	tasks (workspace: ASANA_WORKSPACE; assignee: ASANA_USER): ARRAYED_LIST [ASANA_TASK]
			-- Collection of tasks for `assignee' in `workspace'
		local
			resp: HTTP_CLIENT_RESPONSE
			task: ASANA_TASK
		do
			reset_error
			resp := session.get ("/tasks?workspace=" + workspace.id.out + "&assignee=" + assignee.query_name, new_request_context)
			analyze_response (resp)
			if is_success then
				Result := factory.tasks_from_string (resp.body)
			else
				create Result.make (0)
			end
		end

	tasks_by_user (user_for_tasks: ASANA_USER): ARRAYED_LIST [ASANA_TASK]
			-- Collection of tasks for `user_for_tasks' across all of users' workspaces
		local
			task_list: ARRAYED_LIST [ASANA_TASK]
			i: INTEGER
		do
			create Result.make (0)
			across user_for_tasks.workspaces as workspace
	        loop
				if is_success then
					task_list := tasks (workspace.item, user_for_tasks)
					from
						i := 1
					until
						i > task_list.count
					loop
						Result.extend (task_list[i])
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
		do
			reset_error
			if id = 0 then
				resp := session.get ("/users/me", new_request_context)
			else
				resp := session.get ("/users/" + id.out, new_request_context)
			end
			analyze_response (resp)
			Result := factory.user_from_string (resp.body)
		end

	users: ARRAYED_LIST [ASANA_USER]
			-- Collection of users in this application
		local
			resp: HTTP_CLIENT_RESPONSE
			user: ASANA_USER
			i: INTEGER
		do
			reset_error
			resp := session.get ("/users?opt_fields=name,email,workspaces", new_request_context)
			analyze_response (resp)
			if is_success then
				Result := factory.users_from_string (resp.body)
			else
				create Result.make (0)
			end
		end

	tasks_with_tag (tag: ASANA_TAG): ARRAYED_LIST [ASANA_TASK]
			-- Collection of tasks with tag `tag'.
			-- Resulting tasks are not complete and should be queried for
			-- full task record.
		require
			has_id: tag.id > 0
		local
			resp: HTTP_CLIENT_RESPONSE
			task: ASANA_TASK
			i: INTEGER
		do
			reset_error
			resp := session.get ("/tags/" + tag.id.out + "/tasks", new_request_context)
			analyze_response (resp)
			if is_success then
				Result := factory.tasks_from_string (resp.body)
			else
				create Result.make (0)
			end
		end

feature {NONE} -- Implementation

	factory: ASANA_FACTORY
	
	analyze_response (resp: HTTP_CLIENT_RESPONSE)
			-- Set the `last_error' status using `resp' if an error occurred
			-- otherwise make sure `is_success' is True
		do
			if resp.status > 299 or resp.status = 0 then
				if attached resp.body as resp_body then
					create last_error.make_from_string (resp.status, resp_body)
				else
					create last_error.make_from_string (0, "UNKNOWN ERROR")
				end
			else
				last_error := Void
			end
		end

	session: HTTP_CLIENT_SESSION
			-- HTTP Session for the API application
		local
			h: LIBCURL_HTTP_CLIENT
			l_session: like internal_session
		do
			l_session := internal_session
			if l_session = Void then
				create h.make
				l_session := h.new_session ("https://app.asana.com/api/1.0")
				l_session.set_credentials (api_key, "")
				l_session.set_basic_auth_type
				l_session.set_is_insecure (True)
			end
			Result := l_session
		end

	internal_session: detachable like session

	new_request_context: HTTP_CLIENT_REQUEST_CONTEXT
			-- Request context for the API application
		do
			create Result.make
			Result.headers.put ("application/json", "Content-Type")
			Result.set_credentials_required (True)
		end

end



