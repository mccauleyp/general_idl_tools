function xml_to_struct, xml_string

; ========================================================================================
;+
; NAME: 
;   XML_TO_STRUCT
;
; CATEGORY: 
;   File IO, Strings
;
; PURPOSE: 
;   Convert an XML string into an IDL structure with values casts as their appropriate 
;   data types (numbers will be typed as long or double)
;
; INPUTS: 
;   XML_STRING = (String) XML string data
;
; OUTPUTS: 
;   RETURN = (Structure) XML string as a structure
;
; NOTES:
;   Called by JP2_READ to ingest the XML metadata from JPEG2000 images. 
;
; CALLS: 
;   STR_REPLACE, VALID_NUM
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

;	2016/06/07: Updated so that numbers are treated as such instead of being output as 
;				string data in the structure. Numbers will either be long or double. 

if xml_string eq '' then return, {dummy:'There was no XML header for this file'}

in = xml_string

;find <
pos = intarr(strlen(in))-1
i=0 & ind=0
repeat begin
	now = strpos(in, '<', ind)
	ind = now+1
	pos[i] = now
	i=i+1
endrep until now eq -1
pos = pos[where(pos ne -1)]

pos1 = pos

;find >
pos = intarr(strlen(in))-1
i=0 & ind=0
repeat begin
	now = strpos(in, '>', ind)
	ind = now+1
	pos[i] = now
	i=i+1
endrep until now eq -1
pos = pos[where(pos ne -1)]

pos2 = pos

if n_elements(pos1) ne n_elements(pos2) then begin
	message, 'Found different number of < than >', /info
	return, in
endif

tags = strarr(n_elements(pos1))

for i=0, n_elements(tags)-1 do tags[i] = strmid(in, pos1[i], pos2[i]-pos1[i]+1)
tags = str_replace(str_replace(str_replace(tags, '</', ''), '<', ''), '>', '')

single_item = bytarr(n_elements(tags))
for i=0, n_elements(tags)-2 do if tags[i] eq tags[i+1] then single_item[i] = 1

want = where(single_item eq 1)
tags = tags[want]
tags = str_replace(tags, '-', '_')

info = strarr(n_elements(tags))
duplicate = bytarr(n_elements(tags))

for i=0, n_elements(tags)-1 do begin

	len = strlen(tags[i])+2

	pos1 = strpos(in, '<'+tags[i]+'>')
	pos2 = strpos(in, '</'+tags[i]+'>')
	
	info[i] = strmid(in, pos1+len, pos2-pos1-len)
	
	want = where(tags eq tags[i], count)
	if count gt 1 then duplicate[want[1:*]] = 1

endfor

want = where(duplicate eq 0)
tags = tags[want]
info = info[want]

is_num = valid_num(info) 
is_int = valid_num(info, /integer)
is_flt = is_num - is_int
int_ind = where(is_int eq 1, int_count)
flt_ind = where(is_flt eq 1, flt_count)

types = strarr(n_elements(info))+''' '''
if int_count gt 0 then types[int_ind] = '0L'
if flt_count gt 0 then types[flt_ind] = '0D'

command = 'struct = {'+strjoin(tags+':'+types, ', ')+'}' 

temp = execute(command)
for i=0, n_elements(tags)-1 do struct.(i) = info[i]		

return, struct 
end
