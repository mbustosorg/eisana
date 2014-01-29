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
			Result.set_name (create {UC_UTF8_STRING}.make_from_string (a_name))
			Result.set_notes (create {UC_UTF8_STRING}.make_from_string ("notes for task " + a_name))
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
			tasks: ARRAYED_LIST [ASANA_TASK]
		do
			create tasks.make (0)
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)
			across (1 |..| 5) as i
            loop
            	task := new_task (user, "_testing_ task creation #" + i.item.out)
            	tasks.force (task)
            	assert ("task %"" + task.name + "%" created", asana.is_success)
		    end

		    	-- cleanup, do not report any failure if any, out of the scope of the tests
			across tasks as ic loop
				task := ic.item
				asana.delete_task (task)
		    end
		end

	test_delete_task
			-- Test task deletion
		note
			testing:  "covers/{ASANA_TASK}"
		local
			tasks: ARRAYED_LIST [ASANA_TASK]
			user: ASANA_USER
			task: ASANA_TASK
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)
			tasks := asana.tasks_by_user (user)
			if across tasks as ic some ic.item.name.has_substring ("_testing_") end then
					-- there are _testing_ tasks to delete
			else
				task := new_task (user, "_testing_ task deletion")
				assert ("task %"" + task.name + "%" created", asana.is_success)
				tasks.extend (task)
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
			task.set_name (create {UC_UTF8_STRING}.make_from_string ("name tag _testing_"))
			task.set_notes (create {UC_UTF8_STRING}.make_from_string ("node tag _testing_"))
			task.set_workspace (user.workspaces [1])
			task := asana.new_task (task)
			assert ("task tag test created", asana.is_success)
				-- Assign a tag
			asana.assign_tag (tag, task)
			assert ("task tag assigned", asana.is_success)
				-- Unassign the tag
			asana.remove_tag (tag, task)
			assert ("task tag removed", asana.is_success)
				-- Delete the task
			asana.delete_task (task)
			assert ("task " + task.name + " deleted", asana.is_success)
				-- tag deletion is not available from the API (for now)

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
			project.set_name (create {UC_UTF8_STRING}.make_from_string ("_testing_ project name"))
			project.set_notes (create {UC_UTF8_STRING}.make_from_string ("_testing_ project notes"))
			project.set_workspace (user.workspaces[1])
			project := asana.new_project (project)
			assert ("project created", asana.is_success)
			-- Delete a project
			asana.delete_project (project)
			assert ("project deleted", asana.is_success)
		end

	test_stories
			-- Test stories query
		note
		    testing:  "covers/{ASANA_STORY}"
		local
			user: ASANA_USER
			project: ASANA_PROJECT
			stories: LIST [ASANA_STORY]
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.is_success)

			if attached asana.tasks_by_user (user) as tasks then
				assert ("success", asana.is_success)
				if tasks.is_empty then
				else
					if attached tasks.first as t then
						stories := asana.task_stories (t)
						assert ("success", asana.is_success)
					end
				end
			end

--			-- Create a project
--			create project.make_empty
--			project.set_name (create {UC_UTF8_STRING}.make_from_string ("_testing_ project name"))
--			project.set_notes (create {UC_UTF8_STRING}.make_from_string ("_testing_ project notes"))
--			project.set_workspace (user.workspaces[1])
--			project := asana.new_project (project)
--			assert ("project created", asana.is_success)
--			-- Delete a project
--			asana.delete_project (project)
--			assert ("project deleted", asana.is_success)
		end

end


