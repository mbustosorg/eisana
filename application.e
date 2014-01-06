
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
		local
			users: ARRAY [ASANA_USER]
			task: ASANA_TASK
		do
			users := asana.users
			users.do_all (agent (user: ASANA_USER)
		                    do
								user.workspaces.do_all (agent (workspace: ASANA_WORKSPACE; current_user: ASANA_USER)
		                                                  do
															  asana.tasks (workspace, current_user).do_nothing
														  end
														  (?, user))
							end)
		end

end

