note
    description: "[
                  Object factory for ASANA objects
]"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	ASANA_FACTORY

feature -- Access

	users_from_string (response: detachable READABLE_STRING_8): ARRAYED_LIST [ASANA_USER]
			-- Collection of users from `response'
		deferred
		end

	user_from_string (response: detachable READABLE_STRING_8): ASANA_USER
			-- User from `response'
		deferred
		end

	tasks_from_string (response: detachable READABLE_STRING_8): ARRAYED_LIST [ASANA_TASK]
			-- Collection of tasks from `response'
		deferred
		end
	
	task_from_string (response: detachable READABLE_STRING_8): ASANA_TASK
			-- Task from `response'
		deferred
		end

	workspace_from_string (response: detachable READABLE_STRING_8): ASANA_WORKSPACE
			-- Workspace from `response'
		deferred
		end

	tag_from_string (response: detachable READABLE_STRING_8): ASANA_TAG
			-- Tag from `response'
		deferred
		end

	project_from_string (response: detachable READABLE_STRING_8): ASANA_PROJECT
			-- Project from `response'
		deferred
		end

end
