note
    description: "[
                  http://developers.asana.com/documentation/#projects
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_PROJECT

create
	make_empty,
	make_from_json

feature {NONE} -- Creation

	make_from_json (project: JSON_OBJECT)
			-- Create the project object from `project'
		do
			make_empty
			json := project
			if attached {JSON_NUMBER} json.item ("id") as json_number then
				id := json_number.item.to_integer_64
			end
			if attached {JSON_STRING} json.item ("name") as json_string then
				name := json_string.item
			end
			if attached {JSON_STRING} json.item ("notes") as json_string then
				notes := json_string.item
			end
			if attached {JSON_OBJECT} json.item ("workspace") as workspace_object then
				create workspace.make_from_json (workspace_object)
			end
		end
	
	make_empty
			-- Create an empty project object
		do
			name := ""
			color := ""
			notes := ""
			create modified_at.make_now
			create created_at.make_now
			
			create followers.make_empty
			create workspace.make_empty
			create team.make_empty
			create json.make
		end
	
feature -- Access

	id: INTEGER_64
	archived: BOOLEAN
	created_at: DATE_TIME
	followers: ARRAY [ASANA_USER]
	modified_at: DATE_TIME
	name: STRING assign set_name
	color: STRING
	notes: STRING assign set_notes
	workspace: ASANA_WORKSPACE assign set_workspace
	team: ASANA_TEAM

feature -- Element modification

	set_name (value: STRING)
			-- Set `name' to `value'
		do
			name := value
		end
	
	set_notes (value: STRING)
			-- Set `notes' to `value'
		do
			notes := value
		end
	
	set_workspace (value: ASANA_WORKSPACE)
			-- Set `workspace' to `value'
		do
			workspace := value
		end
	
feature {NONE} -- Implementation

	json: JSON_OBJECT
	
end

