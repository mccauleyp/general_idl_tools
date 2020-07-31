function range_overlap, range1, range2, count=count, indices=indices

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	RANGE_OVERLAP
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Determine if two or more ranges, [start, end], overlap. 
;
; CALLING SEQUENCE:
;	range_overlap, range1, range2 [,count=count] [,indices=indices]
;
; INPUTS: 
;	RANGE1 - (Number Array)
;			Single, two-element array [a,b] that ranges will be compared to. 
;	RANGE2 - (Number array)
;			Same as RANGE1 or an array of ranges, e.g. [ [a1,b1], [a2,b2], [a3,b3], ... ]
;
; OUTPUTS: 
;	RETURN - (Byte)
;			Single byte or byte array with 0 for no overlap and 1 for yes overlap.
;	COUNT - (Integer)
;			Optional output keyword with number of ranges that overlapped.
;	INDICES - (Integer Array)
;			Output keyword with indices of ranges (if RANGE2 was an array of ranges) that 
;			overlapped with RANGE1
;         
; KEYWORDS: 
;	None.
;
; EXAMPLES:
;	IDL> range1 = [1,10]
;	IDL> range2 = [[-10, 0], [2,4], [9,11]]
;	IDL> overlap = range_overlap(range1, range2, count=count, indices=indices)
;	IDL> print, count  
;			   2
;	IDL> print, overlap
;	   0   1   1
;	IDL> print, indices
;			   1           2	
;
; NOTES:
;	Adjoining arrays count as overlapping (e.g. [1,2] and [2,3] would be considered overlapping).
;
; MODIFICATION HISTORY: 
;	2014/02/10 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;	2016/07/21 - Modified so that string inputs will produce an error (not just report no results)
;	2016/10/11 - Fixed bug where an overlap wouldn't be recored if RANGE1 was completely inside RANGE2. 
;
;-
; ========================================================================================

if size(range1, /tname) eq 'STRING' OR size(range2, /tname) eq 'STRING' then begin
	message, 'Oops, input data must be a number.', /info
	return, -1
endif

if range1[0] ge range1[1] then begin
	message, 'Oops, first element of RANGE1 is greater than or equal to the second element.', /info
	return, -1
endif

if n_elements(range1) ne 2 then begin
	message, 'Oops, RANGE1 should have only two elements', /info
	return, -1
endif

sz = size(range2, /dim)

if n_elements(sz) eq 1 then sz = [sz, 1]

overlap = bytarr(sz[1])

for i=0L, sz[1]-1 do begin
	
	greater1 = [(range1[0] ge range2[0,i]), (range1[0] ge range2[1,i])] 
	greater2 = [(range1[1] ge range2[0,i]), (range1[1] ge range2[1,i])] 
	
	lesser1 = [(range1[0] le range2[0,i]), (range1[0] le range2[1,i])] 
	lesser2 = [(range1[1] le range2[0,i]), (range1[1] le range2[1,i])] 
	
	if total([greater1[0],greater2[0]]) eq 2 AND total([lesser1[1],lesser2[1]]) eq 2 then overlap[i] = 1
	if total(greater1) ne total(greater2) OR total(lesser1) ne total(lesser2) then overlap[i] = 1 

endfor

indices = where(overlap eq 1, count)

return, overlap
end
