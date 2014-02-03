note
    description: "[
                  http://developers.asana.com/documentation/#teams
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_team", "src=http://developers.asana.com/documentation/#teams", "protocol=uri"

class
	ASANA_TEAM

inherit
	ASANA_ID_NAME
		redefine
			make_with_id
		end

create
	make_empty

create {ASANA_FACTORY}
	make_with_id

feature {NONE} -- Creation

	make_with_id (a_id: like id)
		do
			Precursor (a_id)
		end

feature -- Access

feature -- Element modification

end
