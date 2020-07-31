function time_sync, time_series, min_step=min_step, trange=trange, in_ref_times=in_ref_times, $
					ref_times=ref_times, keep_repeats=keep_repeats, print=print

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	TIME_SYNC
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Given an arbitrary number of overlapping time series, return matching sets of indices 
;	that can be used to sync the series as closely as possible.  
;
; CALLING SEQUENCE:
;	time_sync, time_series [,min_step=min_step] [,trange=trange] [,in_ref_times=in_ref_times]
;				[,ref_times=ref_times] [,/keep_repeats] [,/print]
;
; INPUTS: 
;	TIME_SERIES - (Pointer Array)
;				Array of separate, overlapping series. Pointers are used so that the series 
;				can be of different lengths. For help on using pointers, see the example 
;				below and the IDL help files. 
;				
; OUTPUTS: 
;	RETURN - (Long Array)
;				[Number of series, matching indices] Array with matching indices. 
;	REF_TIMES - (String Array)
;				Output keyword that contains the reference times that the series were 
;				matched to. Note that this array will not necessarily have a regular 
;				cadence because any repeat matches (instances where the index of every time 
;				series does not change from one REF_TIME to the next) will be removed unless 
;				the KEEP_REPEATS keyword is set. 
;	MIN_STEP - (Double)
;				Output keyword that contains the minimum time jump between REF_TIMES entries. If 
;				the time series had a regular cadence or if the KEEP_REPEATS keyword was set, 
;				the this will be the time cadence for the overall series in seconds.
;	TRANGE - (Double Array)
;				Output keyword with [min, max] time in seconds. 
;         
; KEYWORDS: 
;	KEEP_REPEATS - (Boolean)
;				Set to keep repeating series matches (see above). This will force a regular 
;				cadence. 
;	PRINT - (Boolean) 
;				Set to print the reference times, indices, and corresponding times	
;
; EXAMPLES:
;	IDL> series1 = ['2014/01/01 00:00','2014/01/01 00:02','2014/01/01 00:04','2014/01/01 00:06']
;	IDL> series2 = ['2014/01/01 00:01','2014/01/01 00:05','2014/01/01 00:09']
;	IDL> time_series = ptrarr(2)
;	IDL> time_series[0] = ptr_new(series1)
;	IDL> time_series[1] = ptr_new(series2)
;	IDL> indices = time_sync(time_series, ref_times=ref_times, /print)
;	INDEX:       REF_TIME         ...INDEX1...          TIME1            ...INDEX2...          TIME2  ...
;	0:   2014-01-01T00:00:00.000  ...   0  ...  2014-01-01T00:00:00.000  ...   0  ...  2014-01-01T00:01:00.000
;	1:   2014-01-01T00:02:00.000  ...   1  ...  2014-01-01T00:02:00.000  ...   0  ...  2014-01-01T00:01:00.000
;	2:   2014-01-01T00:04:00.000  ...   2  ...  2014-01-01T00:04:00.000  ...   1  ...  2014-01-01T00:05:00.000
;	3:   2014-01-01T00:06:00.000  ...   3  ...  2014-01-01T00:06:00.000  ...   1  ...  2014-01-01T00:05:00.000
;	4:   2014-01-01T00:08:00.000  ...   3  ...  2014-01-01T00:06:00.000  ...   2  ...  2014-01-01T00:09:00.000
;	IDL> help, indices
;	INDICES         LONG      = Array[2, 5]
;
; NOTES:
;	This routine is intended to sync time series of observations that may be irregularly 
;	spaced so that they can be easily displayed. If there were matching image arrays for 
;	the time series in the example show above, they would get displayed like so:
;	IDL> !p.multi = [0,2,1]
;	IDL> .run 
;	for i=0, n_elements(ref_times)-1 do begin 
;		plot_image, image1[*,*,indices[0,i]]
;		plot_image, image2[*,*,indices[1,i]]
;		wait, 0.2
;	endfor
;	end
;
; MODIFICATION HISTORY: 
;	2014/09/12 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================


t = ptrarr(n_elements(time_series))
for i=0, n_elements(t)-1 do t[i] = ptr_new(anytim(*time_series[i])) ;time series in seconds

if not keyword_set(in_ref_times) then begin

	nfiles = dblarr(n_elements(t)) ;number of times in each series
	tranges = dblarr(2,n_elements(t)) ;min, max time in each series
	min_steps = dblarr(n_elements(t)) ;min time step (cadence) in each series 
	for i=0, n_elements(t)-1 do begin
		nfiles[i] = n_elements(*t[i])
		tranges[*,i] = [min(*t[i]), max(*t[i])]
		if nfiles[i] gt 1 then min_steps[i] = min((*t[i])[1:*] - (*t[i])[0:n_elements(*t[i])-2]) $
		else min_steps[i] = -1 ;if there was only one entry for the time series set to -1
	endfor
	
	want = where(min_steps ne -1, count)
	if count eq 0 then begin
		message, 'Oops, each input time series seems to have only one entry.', /info
		return, -1
	endif
	min_step = min(min_steps[want]) ;set min step for overall series
	trange = [min(tranges[0,*]), max(tranges[1,*])] ;set time range for overall series

	nsteps = ceil((trange[1]-trange[0])/min_step)+1
	ref_times = trange[0]+dindgen(nsteps)*min_step

endif else begin 
	ref_times = anytim(in_ref_times)
	trange = [min(ref_times), max(ref_times)]
	if n_elements(in_ref_times) gt 1 then min_step = min(ref_times[1:*] - ref_times[0:n_elements(ref_times)-2]) $
		else min_step = -1
endelse

;indices array with matchs
indices = lonarr(n_elements(t), n_elements(ref_times))

;cycle through each time series
for i=0, n_elements(t)-1 do begin
	this_series = *t[i]
	;cycle through each reference time
	for j=0, n_elements(ref_times)-1 do begin
		;find the time series entry that best matches the reference time
		temp = min(abs(ref_times[j] - this_series), ind)
		indices[i,j] = ind
	endfor
endfor

;Remove an repeating matches unless KEEP_REPEATS keyword is set
if not keyword_set(keep_repeats) then begin
	uniq_set = bytarr(n_elements(ref_times))+1
	for i=1, n_elements(uniq_set)-1 do begin
		this_set = reform(indices[*,i])
		previous_set = reform(indices[*,i-1])
		if array_equal(this_set, previous_set) eq 1 then uniq_set[i] = 0
	endfor

	want = where(uniq_set eq 1)
	indices=indices[*,want]
	ref_times = ref_times[want]
endif

if keyword_set(print) then begin
	print, 'INDEX:       REF_TIME         ...INDEX1...          TIME1            ...INDEX2...          TIME2  ...'	
	for i=0, n_elements(ref_times)-1 do begin
		line = anytim(ref_times[i], /ccsds)
		for j=0, n_elements(t)-1 do line = line+'  ...   '+trim(indices[j,i])+'  ...  '+anytim((*t[j])[indices[j,i]], /ccsds)
		print, trim(i)+':   '+line
	endfor
endif

return, indices
end
