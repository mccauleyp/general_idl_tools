function clean_nans, img, quiet=quiet, bad=bad, good=good

; ========================================================================================
;+
; PROJECT: 
;	Column Density
;
; NAME: 
;	CLEAN_NANS
;
; CATEGORY: 
;	Image Processing
;
; PURPOSE: 
;	Search an image for NaN or Inf pixels and replace with average value from the 
;	5 nearest finite pixels. 
;
; CALLING SEQUENCE:
;	cleaned = clean_nans( img [,/quiet] [,bad=bad] [,good=good] [,imgs=imgs] [,cleans=cleans])
;
; INPUTS: 
;	IMG = (Float Array)
;		2-d image array
;
; OUTPUTS: 
;	RETURN = (Float Array)
;		Input IMG with NaN and Inf values replaced with average of the 5 nearest pixels. 
;         
; KEYWORDS: 
;	BAD = (Long Array)
;		Indices of bad (NaN/Inf) pixels
;	GOOD = (Long Array)
;		Indices of good (finite) pixels
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

fin = finite(img)
bad = where(fin eq 0, count)
good = where(fin eq 1 AND img ne 0)

if count eq 0 then begin
	if not keyword_set(quiet) then message, 'No NaN or Inf pixels to clean.', /info
	return, img
endif

bad_indices = array_indices(fin, bad)
good_indices = array_indices(fin, good)

cleaned = img

for i=0, count-1 do begin
	dists = sqrt((bad_indices[0,i]-good_indices[0,*])^2 + (bad_indices[1,i]-good_indices[1,*])^2)
	smallest = n_smallest(dists, 3)
	
	cleaned[bad[i]] = mean(img[good[smallest]])
	
endfor

if not keyword_set(quiet) then message, 'Cleaned '+trim(count)+' NaN or Inf pixels.', /info

return, cleaned
end
