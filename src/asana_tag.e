note
    description: "[
                  http://developers.asana.com/documentation/#tags
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_TAG

create
	make_empty,
	make_from_json

feature {NONE} -- Creation

	make_from_json (tag: JSON_OBJECT)
			-- Create the tag object from `tag'
		local
			i: INTEGER
		do
			make_empty
			json := tag
			if attached {JSON_NUMBER} json.item ("id") as json_number then
				id := json_number.item.to_integer_64
			end
			if attached {JSON_STRING} json.item ("name") as json_string_item then
				name := json_string_item.item
			end
			if attached {JSON_STRING} json.item ("color") as json_string_item then
				color := json_string_item.item
			end
			if attached {JSON_STRING} json.item ("notes") as json_string_item then
				notes := json_string_item.item
			end
			if attached {JSON_OBJECT} json.item (create {JSON_STRING}.make_json ("workspace")) as workspace_object then
				create workspace.make_from_json (workspace_object)
			end
		end

	make_empty
			-- Create an empty user object
		do
			create created_at.make_now
			create followers.make_empty
			name := ""
			color := ""
			notes := ""
			create workspace.make_empty
			create json.make
		end
	
feature -- Basic operations

	id: INTEGER_64
	created_at: DATE_TIME
	followers: ARRAY [ASANA_USER]
	name: STRING
	color: STRING
	notes: STRING
	workspace: ASANA_WORKSPACE
	
feature {NONE} -- Implementation

	json: JSON_OBJECT
	
end
