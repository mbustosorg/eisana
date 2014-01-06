note
    description: "[
                  http://developers.asana.com/documentation/#tasks
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_TASK

create
	make_empty,
	make_from_json

feature {NONE} -- Creation

	make_from_json (task: JSON_OBJECT)
			-- Create the task object from `task'
		do
			make_empty
			json := task
			if attached {JSON_NUMBER} json.item ("id") as json_number then
				id := json_number.item.to_integer_64
			end
			if attached {JSON_OBJECT} json.item ("assignee") as json_object then
				create assignee.make_from_json (json_object)
			end
			if attached {JSON_STRING} json.item ("followers") as json_string then
				followers := json_string.item
			end
			if attached {JSON_STRING} json.item ("name") as json_string then
				name := json_string.item
			end
			if attached {JSON_OBJECT} json.item ("workspace") as workspace_object then
				create workspace.make_from_json (workspace_object)
			end
		end
	
	make_empty
			-- Create an empty task object
		do
			create assignee.make_empty
			followers := ""
			name := ""
			notes := ""
            create created_at.make_now
			create completed_at.make_now
			create modified_at.make_now
			create due_on.make_now
			create projects.make_empty
			create assignee_status.make_empty
			--create parent.make_empty
			create workspace.make_empty
			create json.make
		end

feature -- Element modification

	set_assignee (new_user: ASANA_USER)
			-- Set `assignee' to `new_user'
		do
			assignee := new_user
		end

	set_name (new_name: STRING)
			-- Set `name' to 'new_name'
		do
			name := new_name
		end

	set_notes (new_notes: STRING)
			-- Set `notes' to `new_notes'
		do
			notes := new_notes
		end

	set_workspace (new_workspace: ASANA_WORKSPACE)
			-- Set `workspace' to `new_workspace'
		do
			workspace := new_workspace
		end
			
feature -- Access

	id: INTEGER_64
	assignee: ASANA_USER assign set_assignee
	assignee_status: ASANA_ASSIGNEE_STATUS
	created_at: DATE_TIME
	completed: BOOLEAN
	completed_at: DATE_TIME
	due_on: DATE
	followers: STRING
	modified_at: DATE_TIME
	name: STRING assign set_name
	notes: STRING assign set_notes
	projects: ARRAY [ASANA_PROJECT]
	--parent: ASANA_TASK
	workspace: ASANA_WORKSPACE assign set_workspace
	
feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := "ASSIGNEE: " + assignee.json_string + ", " +
				"NAME: " + name.out
		end
	
feature {NONE} -- Implementation

	json: JSON_OBJECT
	
end

