pro textwrangler_syntax, dirs=dirs, orig_plist=orig_plist, new_plist=new_plist, $
						out_dir=out_dir, nocopy=nocopy

; ========================================================================================
;+
; PROJECT: 
;	None
;
; NAME: 
;	TEXTWRANGLER_SYNTAX
;
; CATEGORY: 
;	File I/O
;
; PURPOSE: 
;	Create a new version of 'IDL Configuration.plist', which is used by TextWrangler to 
;	color IDL syntax. Copy this file into the following directory: 
;	~/Library/Application\ Support/TextWrangler/Language\ Modules/ 
;
; CALLING SEQUENCE:
;	html_lines = textwrangler_syntax [,dirs=dirs] [,orig_plist=orig_plist] 
;					[,new_plist=new_plist] [,out_dir=out_dir] [,/nocopy]
;
; INPUTS: 
;	None, but some of the keywords may need to be supplied depending on how you run this 
;	program. See notes. 
;
; OUTPUTS: 
;	No IDL outputs, but a file called 'IDL Configuration.plist' will be written. 
;         
; KEYWORDS: 
;	DIRS = (String)
;		String array of directories to be added. Defaults to ['/usr/local/ssw', '~/code']
;	ORIG_PLIST = (String)
;		Path to original version ('IDL Configuration Orig.plist')
;	NEW_PLIST = (String)
;		Path to new version ('IDL Configuration.plist')
;	OUT_DIR = (String)
;		Path to the equivalent of '~/Library/Application\ Support/TextWrangler/Language\ Modules/' 
;	NOCOPY = (Boolean)
;		Set to not copy NEW_PLIST to OUT_DIR
;
; EXAMPLES:
;
; NOTES:
;
;	This routine required the original version of the .plist file saved as 
;	'IDL Configuration Orig.plist'. If you have expanded your !PATH variable to include 
;	this routine and placed the original plist file in the same directory, then no inputs
;	need to be supplied except for probably the DIRS keyword. 
;
; MODIFICATION HISTORY: 
;	 - 2016/02/29 Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if not keyword_set(plist_sav) then begin
	which, 'textwrangler_syntax', outfile=outfile, /quiet
	dir = str_replace(outfile, file_basename(outfile), '')
	orig_plist = dir+'IDL Configuration Orig.plist'
	if file_test(orig_plist) eq 0 then begin
		message, 'Oops, ORIG_PLIST file not found: '+orig_plist, /info
		return
	endif
	readstring, orig_plist, plist
	if not keyword_set(new_plist) then new_plist = dir+'IDL Configuration.plist'
endif else begin
	if not keyword_set(new_plist) then begin
		message, 'Oops, must also set NEW_PLIST keyword.'
		return
	endif
	readstring, orig_plist, plist
endelse

if not keyword_set(dirs) then dirs = ['/usr/local/ssw', '~/code']


headings = '		<!-- '+dirs+' -->'
insert = ['	<key>BBLMPredefinedNameList</key>', '	<array>']
	

for i=0, n_elements(dirs)-1 do begin
	message, 'Searching for .pro files in '+dirs[i], /info
	list = file_search(dirs[i], '*.pro')
	bases = file_basename(list)

	progs = strupcase(str_replace(bases, '.pro', ''))
	
	xml = '		<string>'+progs+'</string>'
	
	insert = [insert, headings[i], xml, '']
endfor
insert = [insert, '	</array>', '']

want = where(strpos(plist, '<key>BBLMLanguageCode</key>') ne -1, count)
plist_lines = [plist[0:want-1], insert, plist[want:*]]

message, 'Writing new .plist file: '+new_plist, /info
openw, 1, new_plist
	for i=0, n_elements(plist_lines)-1 do printf, 1, plist_lines[i]
close, 1 

if not keyword_set(nocopy) then begin
	if not keyword_set(out_dir) then begin
		out_dir = '~/Library/Application Support/TextWrangler/Language Modules/'
		if file_test(out_dir, /dir) eq 0 then begin
			message, 'Could not automatically find Application Support/TextWrangler/Language Modules, please supply OUT_DIR.', /info
			return
		endif
	endif
	file_copy, new_plist, out_dir, /overwrite 
endif

return
end
