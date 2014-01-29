note
	description: "[
				Summary description for {ASANA_DATE}.
				string format: 2012-02-22
		]"

	date: "$Date$"
	revision: "$Revision$"

class
	ASANA_DATE

inherit
	DEBUG_OUTPUT

create
	make_now_utc,
	make_from_string,
	make_from_date

convert
	make_from_string({READABLE_STRING_8, STRING_8}),
	make_from_date({DATE}),
	string: {STRING_8},
	date: {DATE}

feature {NONE} -- Initialization

	make_now_utc
		do
			make_from_date (create {like date}.make_now_utc)
		end

	make_from_string (s: READABLE_STRING_8)
		do
			internal_string := s
			internal_date := Void

		end

	make_from_date (d: like date)
		do
			internal_date := d
			internal_string := Void
		end

feature -- Access

	date: DATE
		local
			d: like internal_date
		do
			d := internal_date
			if d = Void then
				if attached internal_string as s then
					d := string_to_date (s)
				else
					check has_string: False end
				end
				if d = Void then
					check valid_date: False end
					create d.make_now_utc -- FIXME					
				end
			end
			Result := d
		ensure
			(create {ASANA_DATE}.make_from_date (Result)).string.same_string (string)
		end

	string: STRING
		local
			s: like internal_string
			d: like internal_date
		do
			s := internal_string
			if s = Void then
				d := internal_date
				if d = Void then
					check False end
					create d.make_now_utc
				end
				create s.make (22)
				s.append_integer (d.year)
				s.append_character ('-')
				append_2_digit_to (d.month, s)
				s.append_character ('-')
				append_2_digit_to (d.day, s)
				internal_string := s
			end
			Result := s
		end

feature {NONE} -- Internal

	string_to_date (a_string: READABLE_STRING_8): like internal_date
		local
			p,q: INTEGER
			s: READABLE_STRING_8
			y,mo,d: INTEGER
		do
			q := 1
			p := a_string.index_of ('-', q)
			if p > 0 then
				s := a_string.substring (q, p - 1)
				if s.is_integer then
					y := s.to_integer
					q := p + 1
					p := a_string.index_of ('-', q)
					if p > 0 then
						s := a_string.substring (q, p - 1)
						if s.is_integer then
							mo := s.to_integer
							s := a_string.substring (p + 1, a_string.count)
							if s.is_integer then
								d := s.to_integer
								create Result.make (y, mo, d)
							end
						end
					end
				end
			end
		end

	append_2_digit_to (i: INTEGER; s: STRING_8)
		do
			if i < 10 then
				s.append_character ('0')
			end
			s.append_integer (i)
		end

	internal_date: detachable like date

	internal_string: detachable like string

feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- String that should be displayed in debugger to represent `Current'.
		do
			if attached internal_date as d then
				Result := d.out
			else
				Result := string
			end
		end

end
