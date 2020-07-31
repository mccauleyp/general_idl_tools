function ring_metrics, ring_struct, data

; ========================================================================================
;+
; NAME: 
;   RING_METRICS
;
; CATEGORY: 
;   Mapping, Array Operations
;
; PURPOSE: 
;   Given the output from SORT_INTO_RINGS, return the min, max, mean, median, and stdev
;   values for each ring.
;
; INPUTS: 
;   RING_STRUCT = (Structure) Output from SORT_INTO_RINGS
;
;   DATA = (2D Array) Data array (image) corresponding to RING_STRUCT
;
; OUTPUTS: 
;   RETURN = (Structure) Structure containing the min, max, mean, median, and standard
;            deviation for each ring. This is a single structure where each tag is 
;            a float array with length equal to the number of rings.
;
; KEYWORDS: 
;   NRINGS = (Int) Number of rings to use, default = (image width) / 6
;
;   MIN_R, MAX_R = (Float) Min/Max radius to consider in units of input PIXEL_MAP
;
;   MIN_X, MAX_X = (Float) Min/Max abs(x) to consider in units of input PIXEL_MAP
;
;  MIN_Y, MAX_Y = (Float) Min/Max abs(y) to consider in units of input PIXEL_MAP
;
; NOTES:
;   The RING_WRAPPER routine can be used to combine this code with SORT_INTO_RINGS.
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

r = ring_struct

output = {count:fltarr(r.nrings), min:fltarr(r.nrings), max:fltarr(r.nrings), $
		  mean:fltarr(r.nrings), median:fltarr(r.nrings), sigma:fltarr(r.nrings)}

for i=0, r.nrings-1 do begin

	want = where(r.ring_img eq i, count)

	output.count[i] = count

	if count gt 0 then begin
		output.min[i] = min(data[want])
		output.max[i] = max(data[want])
		output.mean[i] = mean(data[want])
		output.median[i] = median(data[want])
		output.sigma[i] = sigma(data[want])
	endif 

endfor

return, output
end
