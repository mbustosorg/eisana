note
	description: "Summary description for {SHARED_ASANA_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_ASANA_TEST

feature -- testing data		

 	asana: ASANA
 			-- Shared ASANA object using a private api key
 			-- NOTE: removed this private key in the future.
 		local
 			f: RAW_FILE
 			p: PATH
 			k: detachable STRING
 		once
 			create p.make_current
 			p := p.extended ("test").extended ("apikey.txt")
 			create f.make_with_path (p)
 			if f.exists and then f.is_access_readable then
 				f.open_read
 				f.read_line
 				create k.make_from_string (f.last_string)
 				k.left_adjust
 				k.right_adjust
 				f.close
 			end
			if k /= Void and then not k.is_empty then
 				create Result.make (k)
			else
				io.error.put_string ("ERROR: missing or invalid API key!%N")
				io.error.put_string ("Enter a valid ASANA API key in file %""+ p.absolute_path.canonical_path.utf_8_name +"%".%N")
				(create {EXCEPTIONS}).die (-1)
			end
 		end

end
