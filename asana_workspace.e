note
    description: "[
                  http://developers.asana.com/documentation/#workspaces
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_WORKSPACE

inherit
	DEBUG_OUTPUT

create
	make_empty,
	make_from_json

feature {NONE} -- Creation

	make_from_json (workspace: JSON_OBJECT)
			-- Create a workspace object from `workspace'
		do
			make_empty
			json := workspace
			if attached {JSON_NUMBER} json.item ("id") as json_number then
				id := json_number.item.to_integer_64
			end
			if attached {JSON_STRING} json.item ("name") as json_string then
				name := json_string.item
			end
		end
	
	make_empty
			-- Create an empty workspace object
		do
			id := 0
			name := ""
            create json.make
		end
	
feature -- Basic operations
	
	id: INTEGER_64
	name: STRING
	
feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := "ID: " + id.out + ", " +
				"NAME: " + name.out
		end
	
feature {NONE} -- Implementation

	json: JSON_OBJECT
	
end
