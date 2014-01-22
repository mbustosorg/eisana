note
    description: "[
                  http://developers.asana.com/documentation/#users
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_user", "src=http://developers.asana.com/documentation/#users", "protocol=uri"

class
	ASANA_USER

inherit
	DEBUG_OUTPUT

create
	make_empty

feature {NONE} -- Creation

	make_empty
			-- Create an empty user object
		do
			create email.make_empty
			create name.make_empty
			create photo.make_empty
			create workspaces.make (0)
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

	id: INTEGER_64 assign set_id
	email: UC_UTF8_STRING assign set_email
		-- The user's email address.

	name: UC_UTF8_STRING assign set_name
		-- The user's name

	photo: UC_UTF8_STRING assign set_photo
		-- The user's photo.
		-- From the spec, it could be a map or collection of avartar's
		-- but could also be null
		-- Why not define it as detachable photo?


	workspaces: ARRAYED_LIST [ASANA_WORKSPACE]
		-- Workspaces his user may access.

feature -- Element modification

	set_id (value: INTEGER_64)
			-- Set `id' to `value'
		do
			id := value
		end

	set_email (value: UC_UTF8_STRING)
			-- Set `email' to `value'
		do
			email := value
		end

	set_name (value: UC_UTF8_STRING)
			-- Set `name' to `value'
		do
			name := value
		end

	set_photo (value: UC_UTF8_STRING)
			-- Set `photo' to `value'
		do
			photo := value
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

end
