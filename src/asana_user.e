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
	ASANA_ID_NAME
		redefine
			make_with_id,
			debug_output
		end

create
	make_empty

create {ASANA_FACTORY}
	make_with_id

feature {NONE} -- Creation

	make_with_id (a_id: like id)
		do
			Precursor (a_id)
			create email.make_empty
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

	email: UC_UTF8_STRING assign set_email
		-- The user's email address.

	photo: UC_UTF8_STRING assign set_photo
		-- The user's photo.
		-- From the spec, it could be a map or collection of avartar's
		-- but could also be null
		-- Why not define it as detachable photo?


	workspaces: ARRAYED_LIST [ASANA_WORKSPACE]
		-- Workspaces his user may access.

feature -- Element modification

	set_email (value: UC_UTF8_STRING)
			-- Set `email' to `value'
		do
			email := value
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
			Result := Precursor + ", " +
				"EMAIL: " + email.out + ", " +
				"PHOTO: " + photo.out + ", " +
				"WS COUNT: " + workspaces.count.out
		end

end
