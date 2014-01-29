note
	description: "[
				Summary description for {ASANA_DATE_TIME}.
				string format: 2012-02-22T02:06:58.147Z
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	ASANA_DATE_TIME

inherit
	DEBUG_OUTPUT

create
	make_now_utc,
	make_from_string,
	make_from_date_time

convert
	make_from_string({READABLE_STRING_8, STRING_8}),
	make_from_date_time({DATE_TIME}),
	string: {STRING_8},
	date_time: {DATE_TIME},
	date: {DATE}

feature {NONE} -- Initialization

	make_now_utc
			-- Create current date now in UTC timezone.
		do
			make_from_date_time (create {like date_time}.make_now_utc)
		end

	make_from_string (s: READABLE_STRING_8)
			-- Create current date from `s'.
		require
			is_valid_asana_date_string: is_valid_asana_date_time_string (s)
		do
			internal_string := s
			internal_date_time := Void
		end

	make_from_date_time (d: like date_time)
			-- Create current data from `d'.
		do
			internal_date_time := d
			internal_string := Void
		end

feature -- Access

	date_time: DATE_TIME
			-- Associated DATE_TIME object.	
		local
			d: like internal_date_time
		do
			d := internal_date_time
			if d = Void then
				if attached internal_string as s then
					d := string_to_date_time (s)
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
			(create {ASANA_DATE_TIME}.make_from_date_time (Result)).string.same_string (string)
		end

	date: DATE
			-- DATE part of the associated DATE_TIME object.	
		do
			Result := date_time.date
		end

	string: STRING
			-- Associated text representation.	
		local
			s: like internal_string
			d: like internal_date_time
			fd: FORMAT_DOUBLE
		do
			s := internal_string
			if s = Void then
				d := internal_date_time
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

				s.append_character ('T')
				append_2_digit_to (d.hour, s)
				s.append_character (':')
				append_2_digit_to (d.minute, s)
				s.append_character (':')
				create fd.make (2, 3)
				if d.fine_second < 10 then
					s.append_character ('0')
				end
				s.append (fd.formatted (d.fine_second))
				s.append_character ('Z')
				internal_string := s
			end
			Result := s
		ensure
			is_valid_asana_date_time_string (Result)
		end

feature -- Status report

	is_valid_asana_date_time_string (s: READABLE_STRING_8): BOOLEAN
			-- Is `s' a valid asana date time string?
			-- Format: 2014-01-29T16:10:12.345Z
		do
			Result := string_to_date_time (s) /= Void
		end

feature {NONE} -- Internal

	string_to_date_time (a_string: READABLE_STRING_8): like internal_date_time
		local
			p,q: INTEGER
			s: READABLE_STRING_8
			y,mo,d: INTEGER
			h,min: INTEGER
			sec: DOUBLE
		do
			q := 1
			p := a_string.index_of ('-', q)
			if p > 0 then
				s := a_string.substring (q, p - 1)
				if s.is_integer then
					y := s.to_integer -- YEAR
					q := p + 1
					p := a_string.index_of ('-', q)
					if p > 0 then
						s := a_string.substring (q, p - 1)
						if s.is_integer then
							mo := s.to_integer -- MONTH
							q := p + 1
							p := a_string.index_of ('T', q)
							if p > 0 then
								s := a_string.substring (q, p - 1)
								if s.is_integer then
									d := s.to_integer -- DAY
									q := p + 1
									p := a_string.index_of (':', q)
									if p > 0 then
										s := a_string.substring (q, p - 1)
										if s.is_integer then
											h := s.to_integer
											q := p + 1
											p := a_string.index_of (':', q)
											if p > 0 then
												s := a_string.substring (q, p - 1)
												if s.is_integer then
													min := s.to_integer
													q := p + 1
													p := a_string.index_of ('Z', q)
													if p = 0 then
														p := a_string.count + 1
													end
													if p > q then
														s := a_string.substring (q, p - 1)
														if s.is_double then
															sec := s.to_double
														end
													end
													create Result.make_fine (y,mo,d,h,min,sec)
												end
											end
										end
									end
								end
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

	internal_date_time: detachable like date_time

	internal_string: detachable like string

feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- String that should be displayed in debugger to represent `Current'.
		do
			if attached internal_date_time as dt then
				Result := dt.out
			else
				Result := string
			end
		end


end
