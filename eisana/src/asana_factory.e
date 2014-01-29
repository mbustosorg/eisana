note
    description: "[
                  Object factory for ASANA objects
]"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	ASANA_FACTORY

feature -- Factory

	users_from_string (response: detachable READABLE_STRING_8): detachable ARRAYED_LIST [ASANA_USER]
			-- Collection of users from `response'
		deferred
		end

	user_from_string (response: detachable READABLE_STRING_8): detachable ASANA_USER
			-- User from `response'
		deferred
		end

	tasks_from_string (response: detachable READABLE_STRING_8): detachable ARRAYED_LIST [ASANA_TASK]
			-- Collection of tasks from `response'
		deferred
		end

	task_from_string (response: detachable READABLE_STRING_8): detachable ASANA_TASK
			-- Task from `response'
		deferred
		end

	stories_from_string (response: detachable READABLE_STRING_8): detachable ARRAYED_LIST [ASANA_STORY]
			-- Stories related to a task from `response'
		deferred
		end

	workspace_from_string (response: detachable READABLE_STRING_8): detachable ASANA_WORKSPACE
			-- Workspace from `response'
		deferred
		end

	tag_from_string (response: detachable READABLE_STRING_8): detachable ASANA_TAG
			-- Tag from `response'
		deferred
		end

	project_from_string (response: detachable READABLE_STRING_8): detachable ASANA_PROJECT
			-- Project from `response'
		deferred
		end

	team_from_string (response: detachable READABLE_STRING_8): detachable ASANA_TEAM
			-- Project from `response'
		deferred
		end


end
