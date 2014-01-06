
note
	description : "ewfTest application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ASANA_SINGLETON

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			do_nothing
		end

end

