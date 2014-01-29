note
    description: "[
                  http://developers.asana.com/documentation/#tasks
]"
	date: "$Date: $"
	revision: "$Revision: $"
	EIS: "name=asana_task", "src=http://developers.asana.com/documentation/#tasks", "protocol=uri"

class
	ASANA_TASK

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
			create notes.make_empty
            create created_at.make_now_utc
			create completed_at.make_now_utc
			create modified_at.make_now_utc
			create due_on.make_now_utc
			create projects.make (0)
			--create assignee_status.make_empty
			--create parent.make_empty
			create workspace.make_empty
		end

feature -- Element modification

	set_created_at (value: like created_at)
			-- Set `created_at' to `value'
		do
			created_at := value
		end

	set_completed_at (value: like completed_at)
			-- Set `completed_at' to `value'
		do
			completed_at := value
		end

	set_modified_at (value: like modified_at)
			-- Set `modified_at' to `value'
		do
			modified_at := value
		end

	set_completed (value: like completed)
			-- Set `completed' to `value'
		do
			completed := value
		end

	set_due_on (value: like due_on)
			-- Set `due_on' to `value'
		do
			due_on := value
		end

	set_assignee (value: detachable ASANA_USER)
			-- Set `assignee' to `value'
		do
			assignee := value
		end

	set_followers (value: like followers)
			-- Set `followers' to `value'
		do
			followers := value
		end

	set_notes (value: UC_UTF8_STRING)
			-- Set `notes' to `value'
		do
			notes := value
		end

	set_workspace (value: ASANA_WORKSPACE)
			-- Set `workspace' to `value'
		do
			workspace := value
		end

	set_parent_reference (a_ref: detachable ASANA_ID_NAME)
			-- Set `parent_reference' with `a_ref'.
		do
			parent_reference := a_ref
		end

feature -- Access

	assignee: detachable ASANA_USER assign set_assignee
			-- User to which this task is assigned, or null if the task is unassigned.

	--assignee_status: ASANA_ASSIGNEE_STATUS

	created_at: ASANA_DATE_TIME assign set_created_at
			-- The time at which this task was created.

	completed: BOOLEAN assign set_completed
			-- Is the task completed?

	completed_at: ASANA_DATE_TIME assign set_completed_at
			-- The time at which this task was completed.

	due_on: ASANA_DATE assign set_due_on
			-- Date on which this task is due, or null if the task has no due date.
			-- maybe we can define it as detachable.

	followers: detachable ARRAYED_LIST [ASANA_ID_NAME] assign set_followers
			-- Users following this task.
			-- Why not followers: ARRAYED_LIST [ASANA_USER]?

	modified_at: ASANA_DATE_TIME assign set_modified_at
			--  The time at which this task was last modified.

	notes: UC_UTF8_STRING assign set_notes
			-- Information associated with the task.

	projects: ARRAYED_LIST [ASANA_PROJECT]
			-- Projects this task is associated with.

	--parent: ASANA_TASK

	parent_reference: detachable ASANA_ID_NAME assign set_parent_reference
			-- The parent of this task, or null if this is not a subtask.
			-- This property cannot be modified using a PUT request but you can change it with the setParent endpoint.
			-- You can create subtasks by using the subtasks endpoint.

	workspace: ASANA_WORKSPACE assign set_workspace
			-- The workspace this task is associated with.			

end

