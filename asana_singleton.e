note
    description: "[
]"
	date: "$Date: $"
	revision: "$Revision: $"
	
class
	ASANA_SINGLETON

feature {NONE} -- Implementation

	asana: ASANA
			-- The singleton API session
		once
			create Result.make
		end

end
