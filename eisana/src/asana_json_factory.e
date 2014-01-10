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

feature -- Access

	user_from_string (response: detachable READABLE_STRING_8): ASANA_USER
			-- <Precursor>
		local
			parser: JSON_PARSER
			i: INTEGER
		do
			create Result.make_empty
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as json then	
						if attached {JSON_NUMBER} json.item ("id") as json_number then
							Result.id := json_number.item.to_integer_64
						end
						if attached {JSON_STRING} json.item ("email") as json_string_item then
							Result.email := create {UC_UTF8_STRING}.make_from_string (json_string_item.item)
						end
						if attached {JSON_STRING} json.item ("name") as json_string_item then
							Result.name := create {UC_UTF8_STRING}.make_from_string (json_string_item.item)
						end
						if attached {JSON_STRING} json.item ("photo") as json_string_item then
							Result.photo := create {UC_UTF8_STRING}.make_from_string (json_string_item.item)
						end
						if attached {JSON_ARRAY} json.item (create {JSON_STRING}.make_json ("workspaces")) as workspace_objects then
							from
								i := 1
							until
								i > workspace_objects.count
							loop
								if attached {JSON_OBJECT} workspace_objects[i] as workspace_object then
									Result.workspaces.extend (workspace_from_string (workspace_object.representation))
								end
								i := i + 1
							end
						end
					end
				end
			end
		end

	users_from_string (response: detachable READABLE_STRING_8): ARRAYED_LIST [ASANA_USER]	
			-- <Precursor>
		local
			parser: JSON_PARSER
			i: INTEGER
			user: ASANA_USER
		do
			create Result.make (0)
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_ARRAY} j_o.item (create {JSON_STRING}.make_json ("data")) as user_objects then
						from
							i := 1
						until
							i > user_objects.count
						loop
							if attached {JSON_OBJECT} user_objects[i] as user_object then
								user := user_from_string (user_object.representation)
								Result.extend (user)
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
	
	tasks_from_string (response: detachable READABLE_STRING_8): ARRAYED_LIST [ASANA_TASK]
			-- <Precursor>
		local
			parser: JSON_PARSER
			task: ASANA_TASK
		do
			create Result.make (0)
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_ARRAY} j_o.item (create {JSON_STRING}.make_json ("data")) as task_objects then
						across (1 |..| task_objects.count) as i
		                loop
							if attached {JSON_OBJECT} task_objects[i.item] as task_object then
								task := task_from_string (task_object.representation)
								Result.extend (task)
							end
					    end
					end
				end
			end
		end
	
	task_from_string (response: detachable READABLE_STRING_8): ASANA_TASK
			-- <Precursor>
		local
			parser: JSON_PARSER
		do
			create Result.make_empty
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as json then
					if attached {JSON_OBJECT} json.item (create {JSON_STRING}.make_json ("data")) as task_object then
						if attached {JSON_NUMBER} task_object.item ("id") as json_number then
							Result.id := json_number.item.to_integer_64
						end
						if attached {JSON_OBJECT} task_object.item ("assignee") as json_object then
							Result.assignee := user_from_string (json_object.representation)
						end
						if attached {JSON_STRING} task_object.item ("followers") as json_string then
							Result.followers := create {UC_UTF8_STRING}.make_from_string (json_string.item)
						end
						if attached {JSON_STRING} task_object.item ("name") as json_string then
							Result.name := create {UC_UTF8_STRING}.make_from_string (json_string.item)
						end
						if attached {JSON_OBJECT} task_object.item ("workspace") as workspace_object then
							Result.workspace := workspace_from_string (workspace_object.representation)
						end
					end
				end
			end
		end

	workspace_from_string (response: detachable READABLE_STRING_8): ASANA_WORKSPACE
			-- <Precursor>
		local
			parser: JSON_PARSER
		do
			create Result.make_empty
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as json then
					if attached {JSON_NUMBER} json.item ("id") as json_number then
						Result.id := json_number.item.to_integer_64
					end
					if attached {JSON_STRING} json.item ("name") as json_string then
						Result.name := create {UC_UTF8_STRING}.make_from_string (json_string.item)
					end
				end
			end
		end

	tag_from_string (response: detachable READABLE_STRING_8): ASANA_TAG
			-- <Precursor>
		local
			parser: JSON_PARSER
		do
			create Result.make_empty
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as json then
						if attached {JSON_NUMBER} json.item ("id") as json_number then
							Result.id := json_number.item.to_integer_64
						end
						if attached {JSON_STRING} json.item ("name") as json_string_item then
							Result.name := create {UC_UTF8_STRING}.make_from_string (json_string_item.item)
						end
						if attached {JSON_STRING} json.item ("color") as json_string_item then
							Result.color := create {UC_UTF8_STRING}.make_from_string (json_string_item.item)
						end
						if attached {JSON_STRING} json.item ("notes") as json_string_item then
							Result.notes := create {UC_UTF8_STRING}.make_from_string (json_string_item.item)
						end
						if attached {JSON_OBJECT} json.item (create {JSON_STRING}.make_json ("workspace")) as workspace_object then
							Result.workspace := workspace_from_string (workspace_object.representation)
						end
					end
				end
			end
		end

	project_from_string (response: detachable READABLE_STRING_8): ASANA_PROJECT
			-- <Precursor>
		local
			parser: JSON_PARSER
		do
			create Result.make_empty
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as json then
					if attached {JSON_NUMBER} json.item ("id") as json_number then
						Result.id := json_number.item.to_integer_64
					end
					if attached {JSON_STRING} json.item ("name") as json_string then
						Result.name := create {UC_UTF8_STRING}.make_from_string (json_string.item)
					end
					if attached {JSON_STRING} json.item ("notes") as json_string then
						Result.notes := create {UC_UTF8_STRING}.make_from_string (json_string.item)
					end
					if attached {JSON_OBJECT} json.item ("workspace") as workspace_object then
						Result.workspace := workspace_from_string (workspace_object.representation)
					end
				end
			end
		end
	
	team_from_string (response: detachable READABLE_STRING_8): ASANA_TAG
			-- <Precursor>
		local
			parser: JSON_PARSER
		do
			create Result.make_empty
			if attached response then
				create parser.make_parser (response)
				if parser.is_parsed and attached parser.parse_object as j_o then
					if attached {JSON_OBJECT} j_o.item (create {JSON_STRING}.make_json ("data")) as json then
						if attached {JSON_NUMBER} json.item ("id") as json_number then
							Result.id := json_number.item.to_integer_64
						end
						if attached {JSON_STRING} json.item ("name") as json_string then
							Result.name := create {UC_UTF8_STRING}.make_from_string (json_string.item)
						end
					end
				end
			end
		end
	
end
