note
    description: "[
                  http://developers.asana.com/documentation/#stories
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_story", "src=http://developers.asana.com/documentation/#stories", "protocol=uri"

class
	ASANA_STORY

create
	make_empty

create {ASANA_FACTORY}
	make_with_id

feature {NONE} -- Creation

	make_with_id (a_id: like id)
		do
			make_empty
			set_id (a_id)
		end

	make_empty
			-- Create an empty project object
		do
			create created_at.make_now_utc
			create created_by.make_empty
			create text.make_empty
			create source.make_from_string ("unknown")
			create type.make_from_string ("system")
		end

feature -- Access

	id: INTEGER_64 assign set_id

	created_at: ASANA_DATE_TIME assign set_creation_date
		-- The time at which this project was created.

	created_by: ASANA_USER assign set_creator
		-- The user who created the story.

	text: UC_UTF8_STRING assign set_text
		-- Human-readable text for the story or comment.
		-- This will not include the name of the creator.

	target: detachable ASANA_ID_NAME assign set_target
		-- The time at which this project was last mofified.

	source: UC_UTF8_STRING assign set_source
		-- The component of the Asana product the user used to trigger the story.
		-- Valid values are:
		--   web	Via the Asana web app.
		--   email	Via email.
		--   mobile	Via the Asana mobile app.
		--   api	Via the Asana API.
		--   unknown	Unknown or unrecorded.

	type: UC_UTF8_STRING assign set_type
		-- The type of story this is.
		-- Valid values are:
		--    comment	A comment from a user.
		--              The text will be the message portion of the comment.
		--    system	A system-generated story based on a user action.
		--              The text will be a description of the action.		

feature -- Element modification

	set_id (value: INTEGER_64)
			-- Set `id' to `value'
		do
			id := value
		end

	set_creation_date (value: like created_at)
			-- Set `created_at' to `value'
		do
			created_at := value
		end

	set_creator (value: like created_by)
		do
			created_by := value
		end

	set_text (value: like text)
		do
			text := value
		end

	set_source (value: like source)
		do
			source := value
		end

	set_type (value: like type)
		do
			type := value
		end

	set_target (value: like target)
		do
			target := value
		end

end

