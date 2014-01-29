note
    description: "[
                  Object factory for JSON sourced ASANA objects
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_JSON_FACTORY

inherit
	ASANA_FACTORY

feature -- Factory: user

	user_from_string (response: detachable READABLE_STRING_8): detachable ASANA_USER
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := user_from_json (json)
			end
		end

	user_from_json (json: JSON_OBJECT): detachable ASANA_USER
		local
			i: INTEGER
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))

				if attached utf_8_from_json ("email", json) as l_email then
					Result.email := l_email
				end
				if attached utf_8_from_json ("name", json) as l_name then
					Result.name := l_name
				end
				if attached utf_8_from_json ("photo", json) as l_photo then
					Result.photo := l_photo
				end

				if attached {JSON_ARRAY} json.item ("workspaces") as workspace_objects then
					from
						i := 1
					until
						i > workspace_objects.count
					loop
						if attached {JSON_OBJECT} workspace_objects[i] as workspace_object then
							if attached workspace_from_json (workspace_object) as ws then
								Result.workspaces.extend (ws)
							else
								check has_valid_workspace_item: False end
							end
						end
						i := i + 1
					end
				end

			else
				check response_has_id: False end
			end
		end

	users_from_string (response: detachable READABLE_STRING_8): detachable ARRAYED_LIST [ASANA_USER]
			-- <Precursor>
		do
			if attached json_array_data_from_string (response) as json then
				Result := users_from_json_array (json)
			end
		end

	users_from_json_array (json_array: JSON_ARRAY): ARRAYED_LIST [ASANA_USER]
		do
			create Result.make (json_array.count)
			across (1 |..| json_array.count) as ic loop
				if attached {JSON_OBJECT} json_array [ic.item] as user_object then
					if attached user_from_json (user_object) as user then
						Result.extend (user)
						debug ("asana")
							print (user.debug_output + "%N")
							user.workspaces.do_all (agent (ws: ASANA_WORKSPACE)
														do
															print (ws.debug_output + "%N")
														end)
						end
					else
						check has_valid_user_item: False end
					end
				end
		    end
		end

feature -- Factory: task		

	tasks_from_string (response: detachable READABLE_STRING_8): detachable ARRAYED_LIST [ASANA_TASK]
			-- <Precursor>
		do
			if attached json_array_data_from_string (response) as json then
				Result := tasks_from_json_array (json)
			end
		end

	tasks_from_json_array (json_array: JSON_ARRAY): detachable ARRAYED_LIST [ASANA_TASK]
		do
			create Result.make (json_array.count)
			across (1 |..| json_array.count) as i loop
				if attached {JSON_OBJECT} json_array [i.item] as task_object then
					if attached task_from_json (task_object) as l_task then
						Result.extend (l_task)
					else
						check has_valid_task_item: False end
					end
				end
		    end
		end

	task_from_string (response: detachable READABLE_STRING_8): detachable ASANA_TASK
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := task_from_json (json)
			end
		end

	task_from_json (json: JSON_OBJECT): detachable ASANA_TASK
			-- <Precursor>
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))

				if attached boolean_from_json ("completed", json, False) as l_completed then
					Result.completed := l_completed
				end
				if attached date_time_from_json ("created_at", json) as l_created_at then
					Result.created_at := l_created_at
				end
				if attached date_time_from_json ("completed_at", json) as l_completed_at then
					Result.completed_at := l_completed_at
				end
				if attached date_time_from_json ("modified_at", json) as l_modified_at then
					Result.modified_at := l_modified_at
				end
				if attached date_from_json ("due_on", json) as l_due_on then
					Result.due_on := l_due_on
				end

				if attached {JSON_OBJECT} json.item ("assignee") as j_assignee then
					if attached user_from_json (j_assignee) as l_assignee then
						Result.assignee := l_assignee
					else
						check is_valid_assignee: False end
					end
				end
				if attached utf_8_from_json ("name", json) as l_name then
					Result.name := l_name
				end

				if attached {JSON_ARRAY} json.item ("followers") as j_followers then
					Result.followers := id_name_object_list_from_json (j_followers)
				end

				if attached {JSON_OBJECT} json.item ("workspace") as workspace_object then
					if attached workspace_from_json (workspace_object) as ws then
						Result.workspace := ws
					else
						check is_valid_workspace: False end
					end
				end
				if attached {JSON_OBJECT} json.item ("parent") as j_parent then
					Result.parent_reference := id_name_object_from_json (j_parent)
				end
			else
				check has_id: False end
			end
		end

feature -- Factory: story		

	story_from_string (response: detachable READABLE_STRING_8): detachable ASANA_STORY
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := story_from_json (json)
			end
		end

	story_from_json (json: JSON_OBJECT): detachable ASANA_STORY
			-- <Precursor>
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))

				if attached date_time_from_json ("created_at", json) as l_created_at then
					Result.created_at := l_created_at
				end

				if attached {JSON_OBJECT} json.item ("created_by") as j_creator then
					if attached user_from_json (j_creator) as l_creator then
						Result.created_by := l_creator
					else
						check is_valid_created_by: False end
					end
				end

				if attached utf_8_from_json ("text", json) as l_text then
					Result.text := l_text
				end
				if attached utf_8_from_json ("source", json) as l_source then
					Result.source := l_source
				end
				if attached utf_8_from_json ("type", json) as l_type then
					Result.type := l_type
				end
				if attached {JSON_OBJECT} json.item ("target") as j_target then
					Result.target := id_name_object_from_json (j_target)
				end
			else
				check has_id: False end
			end
		end

	stories_from_string (response: detachable READABLE_STRING_8): detachable ARRAYED_LIST [ASANA_STORY]
			-- <Precursor>
		do
			if attached json_array_data_from_string (response) as json then
				Result := stories_from_json_array (json)
			end
		end

	stories_from_json_array (json_array: JSON_ARRAY): detachable ARRAYED_LIST [ASANA_STORY]
		do
			create Result.make (json_array.count)
			across (1 |..| json_array.count) as i loop
				if attached {JSON_OBJECT} json_array [i.item] as story_object then
					if attached story_from_json (story_object) as l_story_object then
						Result.extend (l_story_object)
					else
						check has_valid_story_item: False end
					end
				end
		    end
		end

feature -- Factory: workspace		

	workspace_from_string (response: detachable READABLE_STRING_8): detachable ASANA_WORKSPACE
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := workspace_from_json (json)
			end
		end

	workspace_from_json (json: JSON_OBJECT): detachable ASANA_WORKSPACE
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))

				if attached utf_8_from_json ("name", json) as l_name then
					Result.name := l_name
				end
			else
				check has_id: False end
			end
		end

feature -- Factory: tag		

	tag_from_string (response: detachable READABLE_STRING_8): detachable ASANA_TAG
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := tag_from_json (json)
			end
		end

	tag_from_json (json: JSON_OBJECT): detachable ASANA_TAG
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))

				if attached utf_8_from_json ("name", json) as l_name then
					Result.name := l_name
				end
				if attached utf_8_from_json ("color", json) as l_color then
					Result.color := l_color
				end
				if attached utf_8_from_json ("notes", json) as l_notes then
					Result.notes := l_notes
				end
				if attached {JSON_OBJECT} json.item ("workspace") as workspace_object then
					if attached workspace_from_json (workspace_object) as ws then
						Result.workspace := ws
					else
						check is_valid_workspace: False end
					end
				end
			else
				check has_id: False end
			end
		end

feature -- Factory: project

	project_from_string (response: detachable READABLE_STRING_8): detachable ASANA_PROJECT
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := project_from_json (json)
			end
		end

	project_from_json (json: JSON_OBJECT): detachable ASANA_PROJECT
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))
				if attached utf_8_from_json ("name", json) as l_name then
					Result.name := l_name
				end
				if attached utf_8_from_json ("notes", json) as l_notes then
					Result.notes := l_notes
				end
				if attached {JSON_OBJECT} json.item ("workspace") as workspace_object then
					if attached workspace_from_json (workspace_object) as ws then
						Result.workspace := ws
					end
				end
			else
				check has_id: False end
			end
		end

feature -- Factory: team

	team_from_string (response: detachable READABLE_STRING_8): detachable ASANA_TEAM
			-- <Precursor>
		do
			if attached json_object_data_from_string (response) as json then
				Result := team_from_json (json)
			end
		end

	team_from_json (json: JSON_OBJECT): detachable ASANA_TEAM
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))

				if attached utf_8_from_json ("name", json) as l_name then
					Result.name := l_name
				end
			else
				check has_id: False end
			end
		end

feature {NONE} -- JSON helper

	json_object_data_from_string (s: detachable READABLE_STRING_8): detachable JSON_OBJECT
		local
			parser: JSON_PARSER
		do
			if attached s then
				create parser.make_parser (s)
				if
					parser.is_parsed and then
					attached parser.parse_object as json_doc
				then
					if attached {JSON_OBJECT} json_doc.item ("data") as json_data then
						Result := json_data
					else
						Result := json_doc
					end
				else
					check well_formed_json_data: False end
				end
			end
		end

	json_array_data_from_string (s: detachable READABLE_STRING_8): detachable JSON_ARRAY
		local
			parser: JSON_PARSER
		do
			if attached s then
				create parser.make_parser (s)
				if
					parser.is_parsed and then
					attached parser.parse_object as json_doc
				then
					if attached {JSON_ARRAY} json_doc.item ("data") as json_data then
						Result := json_data
					else
						check has_json_array: False end
					end
				else
					check well_formed_json_data: False end
				end
			end
		end

	id_name_object_from_json (json: JSON_OBJECT): detachable ASANA_ID_NAME
			-- ASANA_ID_NAME object from json.item (k) if possible.
		do
			if json.has_key ("id") then
				create Result.make_with_id (id_from_json ("id", json))
			else
				check has_id: False end
				create Result.make_empty
			end
			if attached utf_8_from_json ("name", json) as l_name then
				Result.name := l_name
			end
		end

	id_name_object_list_from_json (json_array: JSON_ARRAY): ARRAYED_LIST [ASANA_ID_NAME]
			-- ASANA_ID_NAME object from json.item (k) if possible.
		local
			i,n: INTEGER
		do
			from
				i := 1
				n := json_array.count
				create Result.make (n)
			until
				i > n
			loop
				if
					attached {JSON_OBJECT} json_array [i] as json and then
					attached id_name_object_from_json (json) as l_ref
				then
					Result.force (l_ref)
				end
				i := i + 1
			end
		end

	id_from_json (k: STRING; json: JSON_OBJECT): INTEGER_64
		require
			json.has_key (k)
		do
			Result := integer_64_from_json (k, json)
		end

	integer_64_from_json (k: STRING; json: JSON_OBJECT): INTEGER_64
		do
			if attached {JSON_NUMBER} json.item (k) as j_number then
				Result := j_number.item.to_integer_64
			else
				check is_number: False end
			end
		end

	boolean_from_json (k: STRING; json: JSON_OBJECT; dft: BOOLEAN): BOOLEAN
		do
			if json.has_key (k) then
				if attached {JSON_BOOLEAN} json.item (k) as j_boolean then
					Result := j_boolean.item
				else
					check is_boolean: False end
				end
			else
				Result := dft
			end
		end

	utf_8_from_json (k: STRING; json: JSON_OBJECT): detachable UC_UTF8_STRING
		do
			if json.has_key (k) then
				if attached {JSON_STRING} json.item (k) as j_string then
					Result := create {UC_UTF8_STRING}.make_from_string (j_string.item)
				else
					check is_string_or_null: attached {JSON_NULL} json.item (k) end
				end
			end
		end

	date_time_from_json (k: STRING; json: JSON_OBJECT): detachable ASANA_DATE_TIME
		do
			if json.has_key (k) then
				if attached {JSON_STRING} json.item (k) as j_date then
					create Result.make_from_string (j_date.item)
				else
					check is_string_or_null: attached {JSON_NULL} json.item (k) end
				end
			end
		end

	date_from_json (k: STRING; json: JSON_OBJECT): detachable ASANA_DATE
		do
			if json.has_key (k) then
				if attached {JSON_STRING} json.item (k) as j_date then
					create Result.make_from_string (j_date.item)
				else
					check is_string_or_null: attached {JSON_NULL} json.item (k) end
				end
			end
		end

end
