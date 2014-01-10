note
    description: "[
                  http://developers.asana.com/documentation/#users
]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	ASANA_USER

inherit
	DEBUG_OUTPUT

create
	make_empty,
	make_from_json

feature {NONE} -- Creation

	make_from_json (user: JSON_OBJECT)
			-- Create the user object from `user'
		local
			i: INTEGER
		do
			make_empty
			json := user
			if attached {JSON_NUMBER} json.item ("id") as json_number then
				id := json_number.item.to_integer_64
			end
			if attached {JSON_STRING} json.item ("email") as json_string_item then
				email := json_string_item.item
			end
			if attached {JSON_STRING} json.item ("name") as json_string_item then
				name := json_string_item.item
			end
			if attached {JSON_STRING} json.item ("photo") as json_string_item then
				photo := json_string_item.item
			end
			if attached {JSON_ARRAY} json.item (create {JSON_STRING}.make_json ("workspaces")) as workspace_objects then
				from
					i := 1
				until
					i > workspace_objects.count
				loop
					if attached {JSON_OBJECT} workspace_objects[i] as workspace_object then
						workspaces.force (create {ASANA_WORKSPACE}.make_from_json (workspace_object), workspaces.count + 1)
					end
					i := i + 1
				end
			end
		end

	make_empty
			-- Create an empty user object
		do
			id := 0
			email := ""
			name := ""
			photo := ""
			create workspaces.make_empty
			create json.make
		end
	
feature -- Access

	query_name: STRING
			-- Name to be used for user based queries
		do
			if id = 0 then
				Result := "me"
			else
				Result := id.out
			end
		end
	
	id: INTEGER_64
	email: STRING
	name: STRING
	photo: STRING
	workspaces: ARRAY [ASANA_WORKSPACE]

	json_string: STRING
			-- JSON string for `Current'
		do
			Result := json.representation
		end

feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := "ID: " + id.out + ", " +
				"EMAIL: " + email.out + ", " +
				"NAME: " + name.out + ", " +
				"PHOTO: " + photo.out + ", " +
				"WS COUNT: " + workspaces.count.out
		end
	
feature {NONE} -- Implementation

	json: JSON_OBJECT
	
end
