function test_hyperlink, link, count, active=active, broken=broken, qstop=qstop

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	TEST_HYPERLINK
;
; CATEGORY: 
;	HTML
;
; PURPOSE: 
;	Test a URL to see if it exists using WGET. 
;
; CALLING SEQUENCE:
;	result = test_hyperlink(link [,count] [,active=active] [,broken=broken] [,/qstop] )
;
; INPUTS: 
;	LINK - (String or String Array)
;			URL(s) to be tested. 
;
; OUTPUTS: 
;	RETURN - (Byte or Byte Array)	
;			1 if the link exists or 0 if it doesn't. 
;	COUNT - (Integer)
;			Optional output indicating the number of active links.
;         
; KEYWORDS: 
;	ACTIVE - (Integer Array)
;			Indices of active links (from WHERE).
;	BROKEN - (Integer Array)
;			Indices of broken links (from WHERE).
;
; EXAMPLES:
;	IDL> link = 'http://xrt.cfa.harvard.edu/'
;	IDL> print, test_hyperlink(link)
;	       1
;
; NOTES:
;	This routine uses the GNU command-line utility WGET, which needs to be installed for  
;	it to work.
;
; MODIFICATION HISTORY: 
;	2014/08/21 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;	2016/07/20 - Changed loop counter to long integer for long loops. 
;	2016/08/25 - Fixed bug. 
; 	2018/03/27 - Added handling for ftp links
;
;-
; ========================================================================================


if n_elements(link) eq 0 then begin
	message, 'Oops, forgot input', /info
	return, -1
endif

output = bytarr(n_elements(link))+1B

for i=0L, n_elements(link)-1 do begin

	spawn, 'wget --spider '+link[i], result, errResult

	broken = where(strpos(errResult, 'broken link') ne -1 OR strpos(errResult, 'failed') ne -1 OR strpos(errResult, 'No such file') ne -1, count)
	
	if count gt 0 then output[i] = 0B

endfor

active = where(output eq 1B, count, complement=broken)

if keyword_set(qstop) then stop

return, output
end
