function block, str_data, align=align, width=width, nowrap=nowrap, nobreak=nobreak, $
			maxline=maxline

; ========================================================================================
;+
; PROJECT: 
;	mcCatalogs: General
;
; NAME: 
;	BLOCK
;
; CATEGORY: 
;	HTML 
;
; PURPOSE: 
;	Given a string array, return the HTML code for a table "block" div element. 
;
; CALLING SEQUENCE:
;	result = block(str_data [,align=align] [,width=width] [,/nowrap] [,/nobreak] 
;					[,maxline=maxline] )	
;
; INPUTS: 
;	STR_DATA - [Mandatory] (String Array) 
;				Data for table in string form, or in form readily converted to
;				string by the trim() function. Can be single string or string array. 
;				If array, a linebreak is positioned after each entry in the array. 
;
; OUTPUTS: 
;	RETURN - [Mandatory] (String)
;			The function output is a string with the HTML code for a single block, or it's a 
;			string array with HTML code for multiple blocks if the MAXLINE keyword is set.
;         
; KEYWORDS: 
;	ALIGN - [Optiona] (String) 
;			HTML alignment code, e.g. 'left', 'right', or 'middle' (the default)
;	WIDTH - [Optiona] (Integer)
;			Block width in pixels. This is generally defined using separate CSS
;			code that defines the "block" class but can be overwritten using this keyword. 
;			The CSS code is generally generated using the MCCSS.PRO routine. 
;	NOWRAP - [Optiona] (Boolean)
;			Set to at the "nowrap" HTML flag, which will force the block width 
;			to be wide enough to fit the line length. This is not generally recommended 
;			and may clash with the CSS definitions, so BLOCK might not be the best thing 
;			to use if the widths need to be flexible for each block. 
;	NOBREAK - [Optiona] (Boolean) 
;			Set to NOT add a line break (<br>) between each input string array element. 
;	MAXLINE - [Optiona] (Integer) 
;			Set as a limit to the number of lines the block can contain, which 
;			will cause the routine to return a string array of blocks instead of a single 
;			string if the input array (STR_DATA) length exceeds MAXLINE.
;
; EXAMPLES:
;	IDL> block = block(['String1', 'String2'])
;	IDL> print, block
;	<div align="middle" class="block">String1<br>String2</div>
;
; NOTES:
;	The "block" class must be defined by CSS code that is incorporated into the HTML 
;	(either directly or by referencing a separate file). The MCCSS.PRO routine generally 
;	produces this code, which can be adapted to change the block properties.
;
; MODIFICATION HISTORY: 
;	2012/11/26 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if keyword_set(align) then al = ' align="'+align+'"' else al = ' align="middle"'
;if keyword_set(width) then wi = ' width="'+trim(width)+'"' else wi = ''
if keyword_set(width) then wi = ' style="width:'+trim(width)+';"' else wi = ''
if keyword_set(nowrap) then wr = ' nowrap' else wr = ''

if keyword_set(maxline) then begin 
	nblocks = ceil(float(n_elements(str_data))/maxline)
	if nblocks gt 1 then begin 
		block_data = strarr(maxline, nblocks)
		for j=0, nblocks-1 do $
			if j ne nblocks-1 then block_data[*,j]=str_data[j*10:j*10+maxline-1] $
			else begin 
				diff = (n_elements(str_data) mod 10)
				if diff eq 0 then diff = 9 else diff = diff-1
				block_data[0:diff,j] = str_data[j*10:*]
			endelse
	endif
endif else nblocks = 1 

for j=0, nblocks-1 do begin

	if nblocks gt 1 then str_data = block_data[*,j]

	if n_elements(str_data) eq 1 then td = '<div'+al+wi+' class="block">' + trim(str_data) + '</div>' else begin
		td = '<div'+al+wi+wr+' class="block">'
		for i=0, n_elements(str_data)-1 do $
			if i ne n_elements(str_data)-1 then td = td + trim(str_data[i]) + '<br>' $
			else td = td + trim(str_data[i])
		td = td + '</div>'
	endelse
	
	if j eq 0 then block = td else block = block+td
	
endfor

if keyword_set(nobreak) then block = str_replace(block, '<br>', ' ')

return, block
end
