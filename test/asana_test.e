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
	ASANA_SINGLETON
		undefine
			default_create
		end

feature -- Test routines

	test_new_task
			-- Test task creation
		note
			testing:  "covers/{ASANA_TASK}"
		local
			user: ASANA_USER
			task: ASANA_TASK
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.last_error.is_success)
			across (1 |..| 2) as i
            loop
				create task.make_empty
				task.set_assignee (user)
				task.set_name ("name " + i.item.out)
				task.set_notes ("node " + i.item.out)
				task.set_workspace (user.workspaces [1])
				task := asana.new_task (task)
				assert ("task " + i.item.out + " created", asana.last_error.is_success)
		    end
		end

	test_delete_task
			-- Test task deletion
		note
			testing:  "covers/{ASANA_TASK}"
		local
			tasks: ARRAY [ASANA_TASK]
			user: ASANA_USER
		do
			user := asana.user_from_id (0)
			assert ("me found", asana.last_error.is_success)
			tasks := asana.tasks_by_user (user)
			assert ("tasks available", not tasks.is_empty)
			across tasks as task
	        loop
				asana.delete_task (task.item)
				assert ("task " + task.item.name + " deleted", asana.last_error.is_success)
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
			assert ("me found", asana.last_error.is_success)
			-- Create a tag
			tag := asana.new_tag ("test_tag", user.workspaces[1])
			assert ("tag created", asana.last_error.is_success)
			-- Create a task
			create task.make_empty
			task.set_assignee (user)
			task.set_name ("name tag test")
			task.set_notes ("node tag test")
			task.set_workspace (user.workspaces [1])
			task := asana.new_task (task)
			assert ("task tag test created", asana.last_error.is_success)
			-- Assign a tag
			asana.assign_tag (tag, task)
			assert ("task tag assigned", asana.last_error.is_success)
			-- Delete the tag
			asana.remove_tag (tag, task)
			assert ("task tag removed", asana.last_error.is_success)
			-- Delete the task
			asana.delete_task (task)
			assert ("task " + task.name + " deleted", asana.last_error.is_success)
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
			assert ("me found", asana.last_error.is_success)
			-- Create a project
			create project.make_empty
			project.set_name ("test project name")
			project.set_notes ("test project notes")
			project.set_workspace (user.workspaces[1])
			project := asana.new_project (project)
			assert ("project created", asana.last_error.is_success)
			-- Delete a project
			asana.delete_project (project)
			assert ("project deleted", asana.last_error.is_success)
		end
	
end


