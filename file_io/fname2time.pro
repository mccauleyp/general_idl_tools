function fname2time, fnames

times = strarr(n_elements(fnames))
b = file_basename(fnames)

inst = 'unknown'

if strpos(strupcase(b[0]), 'AIA') ne -1 then inst = 'AIA'
if strpos(strupcase(b[0]), 'XRT') ne -1 then inst = 'XRT'
if strpos(strupcase(b[0]), 'HMI') ne -1 then inst = 'HMI'
if strpos(strupcase(b[0]), 'EUB') ne -1 then inst = 'EUVI'
if strpos(strupcase(b[0]), 'EUA') ne -1 then inst = 'EUVI'
if strpos(strupcase(b[0]), 'M_96M') ne -1 then inst = 'MDI'

regex = '([0-9]){4}_([0-9]){2}_([0-9]){2}__'+strjoin(strarr(4)+'([0-9]){2}', '_')
test = stregex(b[0], regex, /extract)
if test ne '' then begin
	t = stregex(b, regex, /extract)
	t = str_replace(strmid(t,0,10),'_','-')+'T'+str_replace(strmid(t,12,8),'_',':')+'.'+strmid(t,21,2)
	return, t
endif 

case inst of
	'AIA': begin
			if strmid(b[0],0,3) eq 'AIA' then t = file2time(b) $
				else t = str_replace(strmid(b, 14, 19), '_', ':')
		end 
	'XRT': t = file2time(b)
	'EUVI': t = file2time(b)
	'HMI': t = strmid(b, 10, 4)+'/'+strmid(b, 15, 2)+'/'+strmid(b, 18, 2)+' '+strmid(b, 21, 2)+':'+strmid(b, 24, 2)+':'+strmid(b, 27, 2)
	else: begin
			message, 'Oops, could not determine instrument for: '+b[0], /info
			return, -1
		end
endcase

times = anytim(t, /ccsds)

return, times
end
