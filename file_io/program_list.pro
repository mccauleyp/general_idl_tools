function program_list, dir

; ========================================================================================
;+
; NAME: 
;   PROGRAM_LIST
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Return a list of all the .pro files in a directory. 
;
; INPUTS: 
;   DIR = '/path/to/directory'
;
; OUTPUTS: 
;   RETURN = String array of program names
;         
; KEYWORDS: 
;   None
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


if file_test(dir, /dir) eq 0 then begin
	message, 'Oops, DIR does not exist.', /info
	return, -1
endif

list = file_search(dir, '*.pro')
bases = file_basename(list)

progs = strupcase(str_replace(bases, '.pro', ''))

return, progs
end
