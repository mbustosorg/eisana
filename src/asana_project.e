note
    description: "[
                  http://developers.asana.com/documentation/#projects
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_project", "src=http://developers.asana.com/documentation/#projects", "protocol=uri"

class
	ASANA_PROJECT

inherit
	ASANA_ID_NAME
		redefine
			make_with_id
		end

create
	make_empty

create {ASANA_FACTORY}
	make_with_id

feature {NONE} -- Creation

	make_with_id (a_id: like id)
		do
			Precursor (a_id)
			create color.make_empty
			create notes.make_empty
			create modified_at.make_now
			create created_at.make_now

			create followers.make (0)
			create workspace.make_empty
			create team.make_empty
		end

feature -- Access

	archived: BOOLEAN
		-- Is the projec archived?

	created_at: DATE_TIME
		-- The time at which this project was created.

	followers: ARRAYED_LIST [ASANA_USER]
		-- Users following this project.

	modified_at: DATE_TIME
		-- The time at which this project was last mofified.

	color: UC_UTF8_STRING
		-- Color of the project

	notes: UC_UTF8_STRING assign set_notes
		-- Information associated with the project.

	workspace: ASANA_WORKSPACE assign set_workspace
		-- The workspace this project is associated with.

	team: ASANA_TEAM
		-- The team that this project is shared with.

feature -- Element modification

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

