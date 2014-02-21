note
	description: "Base class for ASANA entities.  Provide id assignments."
	author: "Mauricio Bustos"
	date: "$Date$"
	revision: "$Revision$"

class
	ASANA_ID_NAME

inherit
	DEBUG_OUTPUT

create
	make_empty

create {ASANA_FACTORY}
	make_with_id

feature {NONE} -- Creation

	make_with_id (a_id: like id)

			-- Create current object with `a_id'.
		do
			set_id (a_id)
			create name.make_empty
		end

	make_empty
			-- Create an empty project object
		do
			make_with_id (0)
		end

feature -- Access

	id: INTEGER_64 assign set_id
			-- Id of the entity

	name: UC_UTF8_STRING assign set_name
			-- Name of the entity.

feature -- Change	

	set_id (value: INTEGER_64)
			-- Set `id' to `value'
		do
			id := value
		end

	set_name (value: like name)
			-- Set `name' to `value'
		do
			name := value
		end

feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := "ID: " + id.out + ", " + "NAME: " + name.out
		end

end
