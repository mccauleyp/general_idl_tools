function td, str_data, align=align, width=width, nowrap=nowrap, nobreak=nobreak

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	TD
;
; CATEGORY: 
;	HTML
;
; PURPOSE: 
;	Return HTML table element code given some input string data.
;
; CALLING SEQUENCE:
;	result = td(str_data  [,align=align] [,width=width] [,/nowrap] [,/nobreak] )
;
; INPUTS: 
;	STR_DATA - [Mandatory] (String Array) 
;				Data for table in string form, or in form readily converted to
;				string by the trim() function. Can be single string or string array. 
;				If array, a linebreak is positioned after each entry in the array. 
;
; OUTPUTS: 
;	RETURN - [Mandatory] (String)
;			The function output is a string with the HTML code for a single TD element.
;         
; KEYWORDS: 
;	ALIGN - [Optiona] (String) 
;			HTML alignment code, e.g. 'left', 'right', or 'middle'. Default is 'left'
;	WIDTH - [Optiona] (Integer)
;			Table element width in pixels. Default is to be unspecified (flexible).  
;	NOWRAP - [Optiona] (Boolean)
;			Set to at the "nowrap" HTML flag, which will force the table element width 
;			to be wide enough to fit the line length. 
;	NOBREAK - [Optiona] (Boolean) 
;			Set to NOT add a line break (<br>) between each input string array element. 
;
; EXAMPLES:
;	IDL> td = td(['String1', 'String2'], align='middle')
;	IDL> print, td
;	<td align="middle">String1<br>String2</td>
;
; NOTES:
;	None.	
;
; MODIFICATION HISTORY: 
;	2012/11/26 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if keyword_set(align) then al = ' align="'+align+'"' else al = ''
if keyword_set(width) then wi = ' width="'+trim(width)+'"' else wi = ''
if keyword_set(nowrap) then wr = ' nowrap' else wr = ''
if n_elements(str_data) eq 1 then td = '<td'+al+wi+'>' + trim(str_data) + '</td>' else begin
	td = '<td'+al+wi+wr+'>'
	for i=0, n_elements(str_data)-1 do $
		if i ne n_elements(str_data)-1 then td = td + trim(str_data[i]) + '<br>' $
		else td = td + trim(str_data[i])
	td = td + '</td>'
endelse
if keyword_set(nobreak) then td = str_replace(td, '<br>', ' ')
return, td
end
