note
    description: "[
                  http://developers.asana.com/documentation/#workspaces
		]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_workspaces", "src=http://developers.asana.com/documentation/#workspaces", "protocol=uri"

class
	ASANA_WORKSPACE

inherit
	ASANA_ID_NAME

create
	make_empty

create {ASANA_FACTORY}
	make_with_id

feature {NONE} -- Creation


end
