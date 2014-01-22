note
    description: "[
                  http://developers.asana.com/documentation/#tags
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_tag", "src=http://developers.asana.com/documentation/#tags", "protocol=uri"

class
	ASANA_TAG

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty tag object
		do
			create created_at.make_now
			create followers.make (0)
			create name.make_empty
			create color.make_empty
			create notes.make_empty
			create workspace.make_empty
		end

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

	set_color (value: UC_UTF8_STRING)
			-- Set `color' to `value'
		do
			color := value
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

	created_at: DATE_TIME
		-- The time at which this tag was created.

	followers: ARRAYED_LIST [ASANA_USER]
		-- Users following this tag.

	name: UC_UTF8_STRING assign set_name
		-- Tag name.

	color: UC_UTF8_STRING assign set_color
		-- Color of the tag.

	notes: UC_UTF8_STRING assign set_notes
		-- Information

	workspace: ASANA_WORKSPACE assign set_workspace
		-- The workspace this tag is associated with.
end
