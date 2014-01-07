note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	ASANA_TEST

inherit
	EQA_TEST_SET

	SHARED_ASANA_TEST
		undefine
			default_create
		end

feature -- Test routines

	new_task (u: ASANA_USER; a_name: READABLE_STRING_8): ASANA_TASK
		local
			user: ASANA_USER
		do
			create Result.make_empty
			Result.set_assignee (u)
			Result.set_name (a_name)
			Result.set_notes ("notes for task " + a_name)
			Result.set_workspace (u.workspaces [1])
			Result := asana.new_task (Result)
		end

	test_new_task
			-- Test task creation
		note
			testing:  "covers/{ASANA_TASK}"
		local
			user: ASANA_USER
			task: ASANA_TASK
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)
			across (1 |..| 2) as i
            loop
            	task := new_task (user, "_testing_ task creation #" + i.item.out)
            	assert ("task %"" + task.name + "%" created", asana.is_success)
		    end
		end

	test_delete_task
			-- Test task deletion
		note
			testing:  "covers/{ASANA_TASK}"
		local
			tasks: ARRAY [ASANA_TASK]
			user: ASANA_USER
			task: ASANA_TASK
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)
			tasks := asana.tasks_by_user (user)
			if tasks.is_empty then
				task := new_task (user, "_testing_ task deletion")
				assert ("task %"" + task.name + "%" created", asana.is_success)
				tasks.force (task, 1)
			end
			assert ("tasks available", not tasks.is_empty)
			across tasks as ic loop
				task := ic.item
	        	if task.name.has_substring ("_testing_") then
					asana.delete_task (task)
					assert ("task " + task.name + " deleted", asana.is_success)
	        	end
		    end
		end

	test_tags
			-- Test tag creation
		note
		    testing:  "covers/{ASANA_TAG}"
		local
			user: ASANA_USER
			tag: ASANA_TAG
			task: ASANA_TASK
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)
			-- Create a tag
			tag := asana.new_tag ("_testing_tag", user.workspaces[1])
			assert ("tag created", asana.is_success)
			-- Create a task
			create task.make_empty
			task.set_assignee (user)
			task.set_name ("name tag test")
			task.set_notes ("node tag test")
			task.set_workspace (user.workspaces [1])
			task := asana.new_task (task)
			assert ("task tag test created", asana.is_success)
			-- Assign a tag
			asana.assign_tag (tag, task)
			assert ("task tag assigned", asana.is_success)
			-- Delete the tag
			asana.remove_tag (tag, task)
			assert ("task tag removed", asana.is_success)
			-- Delete the task
			asana.delete_task (task)
			assert ("task " + task.name + " deleted", asana.is_success)
		end

	test_project
			-- Test project creation / deletion
		note
		    testing:  "covers/{ASANA_PROJECT}"
		local
			user: ASANA_USER
			project: ASANA_PROJECT
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)
			-- Create a project
			create project.make_empty
			project.set_name ("_testing_ project name")
			project.set_notes ("_testing_ project notes")
			project.set_workspace (user.workspaces[1])
			project := asana.new_project (project)
			assert ("project created", asana.is_success)
			-- Delete a project
			asana.delete_project (project)
			assert ("project deleted", asana.is_success)
		end

end


