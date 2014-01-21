note
    description: "[
                  http://developers.asana.com/documentation/#workspaces
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_workspaces", "src=http://developers.asana.com/documentation/#workspaces", "protocol=uri"

class
	ASANA_WORKSPACE

inherit
	DEBUG_OUTPUT

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty workspace object
		do
			create name.make_empty
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

feature -- Basic operations

	id: INTEGER_64 assign set_id
	name: UC_UTF8_STRING assign set_name
		-- Name of the workspace.

feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := "ID: " + id.out + ", " +
				"NAME: " + name.out
		end

end
