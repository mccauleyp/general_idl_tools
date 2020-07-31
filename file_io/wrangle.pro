pro wrangle, program, all=all 

; ========================================================================================
;+
; NAME: 
;   WRANGLE
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Open an IDL file in TextWrangle from the command line from its name only
;
; INPUTS: 
;   PROGRAM = String, name of routine
;
; OUTPUTS: 
;   None, file opened in TextWrangler (or whatever 'edit' is mapped to in your shell)
;         
; KEYWORDS: 
;   ALL = Boolean, set to open all instances of that routine if there are multiple in 
;         !PATH
;
; EXAMPLES:
;   wrangle, 'plot_image'
;
; NOTES:
;   Uses WHICH to find the file and SPAWN to open it. 
;
;   TextWranlger is now deprecated in favor of BBEdit and I haven't needed to update this. 
;   Feel free to contact me if you're interested in a modified version or email me 
;   with the updated version if you do it yourself.  
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


program = trim(program)

which, program, outfile=outfile, /quiet, /all
if outfile[0] eq '' then begin 
	message, 'Oops, '+strupcase(program)+' not found in !PATH.', /info
	return
end

if strpos(outfile[0], 'is an IDL built-in routine.') ne -1 then begin
	message, 'Oops, '+outfile, /info
	return
endif

if keyword_set(all) then begin
	command = 'edit '+strjoin(outfile, ' ')
	for i=0, n_elements(outfile)-1 do message, 'Opened '+outfile[i], /info
endif else begin
	command = 'edit '+outfile[0]
	message, 'Opened '+outfile[0], /info
	if n_elements(outfile) gt 1 then message, 'Also in !PATH: '+strjoin(outfile[1:*], ', '), /info
endelse

spawn, command, result, errResult

if errResult ne '' then begin
	message, 'Oops, error in SPAWN command: '+errResult, /info
	return
endif 

return
end
