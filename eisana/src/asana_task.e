note
    description: "[
                  http://developers.asana.com/documentation/#tasks
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_task", "src=http://developers.asana.com/documentation/#tasks", "protocol=uri"

class
	ASANA_TASK

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty task object
		do
			create assignee.make_empty
			create followers.make_empty
			create name.make_empty
			create notes.make_empty
            create created_at.make_now
			create completed_at.make_now
			create modified_at.make_now
			create due_on.make_now
			create projects.make (0)
			--create assignee_status.make_empty
			--create parent.make_empty
			create workspace.make_empty
		end

feature -- Element modification

	set_id (value: INTEGER_64)
			-- Set `id' to `value'
		do
			id := value
		end
	
	set_assignee (value: ASANA_USER)
			-- Set `assignee' to `value'
		do
			assignee := value
		end

	set_followers (value: UC_UTF8_STRING)
			-- Set `followers' to `value'
		do
			followers := value
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
			
feature -- Access

	id: INTEGER_64 assign set_id
	assignee: ASANA_USER assign set_assignee
	--assignee_status: ASANA_ASSIGNEE_STATUS
	created_at: DATE_TIME
	completed: BOOLEAN
	completed_at: DATE_TIME
	due_on: DATE
	followers: UC_UTF8_STRING assign set_followers
	modified_at: DATE_TIME
	name: UC_UTF8_STRING assign set_name
	notes: UC_UTF8_STRING assign set_notes
	projects: ARRAYED_LIST [ASANA_PROJECT]
	--parent: ASANA_TASK
	workspace: ASANA_WORKSPACE assign set_workspace
	
end

