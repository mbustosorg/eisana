note
    description: "[
                  http://developers.asana.com/documentation/#projects
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_project", "src=http://developers.asana.com/documentation/#projects", "protocol=uri"

class
	ASANA_PROJECT

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty project object
		do
			create name.make_empty
			create color.make_empty
			create notes.make_empty
			create modified_at.make_now
			create created_at.make_now
			
			create followers.make (0)
			create workspace.make_empty
			create team.make_empty
		end
	
feature -- Access

	id: INTEGER_64 assign set_id
	archived: BOOLEAN
	created_at: DATE_TIME
	followers: ARRAYED_LIST [ASANA_USER]
	modified_at: DATE_TIME
	name: UC_UTF8_STRING assign set_name
	color: UC_UTF8_STRING
	notes: UC_UTF8_STRING assign set_notes
	workspace: ASANA_WORKSPACE assign set_workspace
	team: ASANA_TEAM

feature -- Element modification

	set_id (value: INTEGER_64)
			-- Set `id' to `value'
		do
			id := value
		end
	
	set_name (value: UC_UTF8_STRING)
			-- Set `name' to `value'
		do
			name := value
		end
	
	set_notes (value: UC_UTF8_STRING)
			-- Set `notes' to `value'
		do
			notes := value
		end
	
	set_workspace (value: ASANA_WORKSPACE)
			-- Set `workspace' to `value'
		do
			workspace := value
		end
	
end

