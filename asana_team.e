note
    description: "[
                  http://developers.asana.com/documentation/#teams
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_TEAM

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
		end
	
	make_empty
			-- Create an empty project object
		do
			name := ""
			create json.make
		end
	
feature -- Access

	id: INTEGER_64
	name: STRING

feature {NONE} -- Implementation

	json: JSON_OBJECT
	
end
