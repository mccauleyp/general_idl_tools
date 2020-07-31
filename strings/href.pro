function href, link, text, lightbox=lightbox, escape_quote=escape_quote, newtab=newtab

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	HREF
;
; CATEGORY: 
;	HTML
;
; PURPOSE: 
;	Return HTML hyperlink code given the URL(s) and corresponding text.
;
; CALLING SEQUENCE:
;	result = href(link, text [,/newtab] [,/lightbox] [,/escape_quote] )
;
; INPUTS: 
;	LINK - [Mandatory] (String)
;		URL (e.g. 'http://xrt.cfa.harvard.edu/'). May also be a string array.
;	TEXT - [Mandatory] (string
;		Text to be displayed as hyperlink. Should have same number of elements as LINK.
;
; OUTPUTS: 
;	RETURN - [Mandatory] (String)
;			Hyperlink code (e.g. '<A HREF="http://xrt.cfa.harvard.edu/">Hinode/XRT</A>')
;         
; KEYWORDS: 
;	NEWTAB - [Optional] (Boolean)
;				Set for link to be opened in a new browser tab
;	LIGHTBOX - [Optional] (Boolean)
;				Set for link to be opened as a jQuery lightbox element (requires lightbox 
;				code to be implemented in HTML page).
;	ESCAPE_QUOTE - [Optional] (Boolean)
;				Set to escape double quote (i.e. " -> \") 
;
; EXAMPLES:
;	IDL> link = 'http://xrt.cfa.harvard.edu/'
;	IDL> text = 'Hinode/XRT'
;	IDL> print, href(link, text)
;	<A HREF="http://xrt.cfa.harvard.edu/">Hinode/XRT</A>
;
; NOTES:
;	None.	
;
; MODIFICATION HISTORY: 
;	2012/11/26 - Written by Patrick McCauley
;
;-
; ========================================================================================

if n_elements(link) ne n_elements(text) then begin
	box_message, ['LINK and TEXT variables must have same number of elements']
	return, 'error'
endif

if keyword_set(lightbox) then li = ' rel="lightbox"' else li = ''
if keyword_set(newtab) then nt = ' target="_blank"' else nt = ''

if n_elements(link) eq 1 then href = '<A HREF="' + link + '"'+li+nt+'>' + text + '</A>' else begin	
	href = strarr(n_elements(link))
	for i=0, n_elements(link)-1 do href[i] = '<A HREF="' + link[i] + '"'+li+nt+'>' + text[i] + '</A>'
endelse

if keyword_set(escape_quote) then href = str_replace(href, '"', '\"')

return, href
end
