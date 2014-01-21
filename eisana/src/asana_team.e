note
    description: "[
                  http://developers.asana.com/documentation/#teams
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_team", "src=http://developers.asana.com/documentation/#teams", "protocol=uri"

class
	ASANA_TEAM

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty team object
		do
			create name.make_empty
		end

feature -- Access

	id: INTEGER_64 assign set_id

	name: UC_UTF8_STRING assign set_name
		-- Name of the team.
		
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

end
