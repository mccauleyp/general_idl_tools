function txt_to_struct, file, delimiter=delimiter, range=range, reach=reach, tags=tags

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	TXT_TO_STRUCT
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Convert a delimited text file into an IDL structure. 
;
; CALLING SEQUENCE:
;	result = txt_to_struct(file [,delimiter=delimiter] [,range=range] [,reach=reach] [,tags=tags] )
;
; INPUTS: 
;	FILE - (String)
;			'/path/to/input/file.txt'. The first row of this text file should contain the 
;			column names, which will be used for the structure tags. 
;
; OUTPUTS: 
;	RETURN - (Structure Array)
;			Structure array with number of elements equal to the number of populated rows 
;			in the text file. 
;         
; KEYWORDS: 
;	DELIMITER - (String)
;			The delimiter for the text file. The default is tab-delimited (string(9B))
;	RANGE - (Integer Array)
;			[start, stop] Range of lines to be considered. Lines outside will be ignored.
;	REACH - (Integer)
;			Alternative way of specifying range. RANGE = [nrows - reach -1, nrows -1]
;	TAGS - (String Array)
;			Tags to be used for structure. This is an alternative to having the tags be 
;			defined by the first row of the text file. 
;
; EXAMPLES:
;	IDL> struct = txt_to_struct('data.txt')
;	
; NOTES:
;	None. 
;
; MODIFICATION HISTORY: 
;	2012/11/24 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if not keyword_set(delimiter) then delimiter = string(9B) ;string(9B) = tab

readstring, file, rows

if not keyword_set(range) then range = [0, n_elements(rows)-1]
if keyword_set(reach) then range = [n_elements(rows)-1 - reach, n_elements(rows)-1]

;if range[0] gt 0 then rows = [rows[0], rows[range[0]:range[1]]] else rows = rows[rang[0]:range[1]]
rows = rows[range[0]:range[1]]

;filter out empty rows (indicated by a delimiter as first character)
rows = rows[where(strmid(rows,0,1) ne delimiter)]

if keyword_set(tags) then rows = [tags, rows]

for i=0, n_elements(rows)-1 do begin

	tabs = strsplit(rows[i], delimiter) ;locations of delimiters in row

	;Determine distance between each delimiter:
	lengths = intarr(n_elements(tabs)) 
	for j=0, n_elements(lengths)-1 do $
		if j eq n_elements(lengths)-1 then lengths[j] = strlen(rows[i]) - tabs[j] $
		else lengths[j] = tabs[j+1] - tabs[j] -1
	
	;Parse out content between delimiters	
	elements = strarr(n_elements(tabs))
	for j=0, n_elements(elements)-1 do elements[j] = str_replace(strmid(rows[i],tabs[j],lengths[j]), delimiter, '')
	
	;If reading the first row, use content to create base output structure
	if i eq 0 then begin
		format = strarr(n_elements(elements))
		format[*] = 'A' ;'A' = string format
		;create anonymous structure called base that has tag names taken from the
		;elements array and tag formats taken from the format array
		create_struct, base, '', trim(elements), format
	;If not reading the first row, use content to create structures for each element
	endif else begin
		temp = base
		for j=0, n_elements(elements)-1 do temp.(j) = elements[j]
		if n_elements(structarr) eq 0 then structarr = temp else structarr = concat_struct(structarr, temp)
	endelse
endfor

return, structarr
end
