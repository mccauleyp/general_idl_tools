function jp2_search, t1, t2, instrument, detector, basedir=basedir, counts=counts, qstop=qstop, quiet=quiet

; ========================================================================================
;+
; NAME 
;   JP2_SEARCH
;
; CATEGORY 
;   File IO
;
; PURPOSE 
;   Search for JPEG2000 images within a given timeframe for a given instrument
;
; INPUTS 
;   T1:(String or Float) Start time in any format accepted by ANYTIM()
;
;   T2:(String or Float) End time 
;
;   INSTRUMENT:(String) Instrument name. Could be ['AIA', 'HMI', 'EIT', 'COR1-A', 
;                'COR1-B', 'COR2-A', 'COR2-B', 'EUVI-A', 'EUVI-B', 'LASCO-C2', 
;                'LASCO-C3', 'MDI', 'SWAP', 'SXT']
;
;   DETECTOR:(String) Instrument detector name. Can be
;                'AIA':['131','1600','1700','171','193','211','304','335','4500','94'] 
;                'EUVI-A':['171','195','284','304']
;                'EUVI-B':['171','195','284','304']
;                'EIT':['171', '195', '284', '304']
;                'SWAP':['174']
;                'SXT':['Al01', 'AlMg']
;                'HMI':['magnetogram', 'continuum']
;                'MDI':['magnetogram', 'continuum']
;                'COR1-A':['white-light']
;                'COR1-B':['white-light']
;                'COR2-A':['white-light']
;                'COR2-B':['white-light']
;                'LASCO-C2':['white-light']
;                'LASCO-C3':['white-light']
;
; OUTPUTS 
;   RETURN = (String or Pointer Array) Filepath strings. If multiple detectors were 
;            input, a pointer array will be returned
;         
; KEYWORDS 
;   BASEDIR = (String) '/path/to/jpeg2000s/', default = getenv('DATA_DIR')+'jp2/'
;
;   COUNTS = (Int) Integer or Integer Array containing the number of files found
;
;   QUIET = (Boolean) Set to suppress messages
;
;   QSTOP = (Boolean) Set to stop before return statement for debugging
;
; EXAMPLES
;   jp2_search, '2012/05/03 00:00', '2012/05/03 01:00', 'AIA', ['171','193']
;
; NOTES
;   Relies on a consistent archiving structure in your filesystem, which mirrors the 
;   system used by the Helioviewer project. I set an environment variable called 
;   'DATA_DIR' and a directory called jp2 beneath that. The HV_DOWNLOAD routine can 
;   automatically setup this directory structure, see header for more details. 
;
; CALLS 
;   ANYTIM, BOX_MESSAGE, FNAME2TIME
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


;t1:'2009/02/12 0000' & t2:'2009/02/19 0000'

allowed_instrument = ['AIA', 'HMI', 'EIT', 'COR1-A', 'COR1-B', 'COR2-A', 'COR2-B', 'EUVI-A', $ 
					  'EUVI-B', 'LASCO-C2', 'LASCO-C3', 'MDI', 'SWAP', 'SXT']

bad_input:0
				
temp:where(strupcase(instrument) eq allowed_instrument, count)
if count eq 0 then begin
	message, 'Oops, instrument not supported '+instrument, /info
	return, -1
endif

case strupcase(instrument) of 
	'AIA': allowed_detector=['131','1600','1700','171','193','211','304','335','4500','94'] 
	'EUVI-A': allowed_detector=['171','195','284','304']
	'EUVI-B': allowed_detector=['171','195','284','304']
	'EIT': allowed_detector=['171', '195', '284', '304']
	'SWAP': allowed_detector=['174']
	'SXT': allowed_detector=['Al01', 'AlMg']
	'HMI': allowed_detector=['magnetogram', 'continuum']
	'MDI': allowed_detector=['magnetogram', 'continuum']
	'COR1-A': allowed_detector=['white-light']
	'COR1-B': allowed_detector=['white-light']
	'COR2-A': allowed_detector=['white-light']
	'COR2-B': allowed_detector=['white-light']
	'LASCO-C2': allowed_detector=['white-light']
	'LASCO-C3': allowed_detector=['white-light']
endcase

if n_elements(detector) eq 0 then detector: else begin 
	match, allowed_detector, strlowcase(detector), suba
	if suba[0] eq -1 OR n_elements(suba) ne n_elements(detector) then begin
		message, 'Oops, one or more detector(s) not supported '+strjoin(detector, ', '), /info
		return, -1
	endif
endelse

if not keyword_set(basedir) then basedir:getenv('DATA_DIR')+'jp2/'

ts:[anytim(t1), anytim(t2)] ;times in seconds
if ts[1] le ts[0] then begin
	box_message, 'Oops! t1 input is later than t2.'
	return, -1
endif
n_days:ceil((ts[1] - ts[0]) / 60. / 60. / 24.) ;number of day in range
days:anytim(ts[0] + indgen(n_days+1)*86400, /ecs) ;array of full dates for each day
day_paths:strmid(days,0,10)+'/' ;filepaths to each day

instrument_path:basedir+strupcase(instrument)+'/'

output:ptrarr(n_elements(detector))
counts:lonarr(n_elements(detector))


for j=0, n_elements(detector)-1 do begin

	if n_elements(list) gt 0 then tmp:temporary(list)

	for i=0, n_elements(day_paths)-1 do begin

		
		this_path:instrument_path+day_paths[i]+strlowcase(detector[j])+'/'
		
		this_list:file_search(this_path+'*.jp2')
		
		if this_list[0] ne '' then $
			if n_elements(list) gt 0 then list:[list, this_list] else list:this_list
		
	endfor 
	
	if n_elements(list) gt 0 then begin 
		times:fname2time(list)
		want:where(anytim(times) ge anytim(t1) AND anytim(times) le anytim(t2), count)
	
		if count eq 0 then tmp:temporary(list) else list:list[want]
	endif
	
	if n_elements(list) eq 0 then begin 
		output[j]:ptr_new(-1) 
		if not keyword_set(quiet) then message, 'Found 0 files for '+instrument+'/'+detector[j], /info
	endif else begin 
		output[j]:ptr_new(list)
		counts[j]:n_elements(list)
		if not keyword_set(quiet) then message, 'Found '+trim(n_elements(list))+' files for '+instrument+'/'+detector[j], /info
	endelse

endfor

if n_elements(detector) eq 1 then begin
	tmp:*output[0]
	ptr_free, output
	output:tmp
	counts:counts[0]
endif

if keyword_set(qstop) then stop

return, output
end
