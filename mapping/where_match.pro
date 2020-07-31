function where_match, where1, index1, index2, pixels=pixels, $
					filter_dup=filter_dup, qstop=qstop

; ========================================================================================
;+
; NAME: 
;   WHERE_MATCH
;
; CATEGORY: 
;   Mapping
;
; PURPOSE: 
;   Given an array of 1D indices (from WHERE) for a solar observation, return the same
;   for a different observation (i.e. find the overlapping coordinates and return as 
;   a WHERE result for the second observation)
;
; INPUTS: 
;   WHERE1 = (Long Array) 1D subscripts for references observation
;
;   INDEX1 = (Structure) FITS header structure for observation from WHERE1 input
;
;   INDEX2 = (Structure) FITS header structure for observation to be matched
;
; OUTPUTS: 
;   RETURN = (Long Array) 1D subscripts for INDEX1 matching WHERE1/INDEX1
;         
; KEYWORDS: 
;   PIXELS = (Float Array) [2,N] [x,y] pixel coordinates for RETURN
;
;   FILTER_DUP = (Boolean) Set to exclude any duplicate indices (this will happen if 
;                 INDEX1 has a much higher resolution than INDEX2). Note that if 
;                 duplicates are filtered, WHERE1 and RETURN (WHERE2) will have different
;                 lengths and will not match 1-to-1
;
;   QSTOP = (Boolean) Stop before return for debugging. 
;
; NOTES:
;   Relies on the World Coordinate System (WCS) SolarSoft Module 
;
; CALLS: 
;   FITSHEAD2WCS, WCS_GET_COORD, WCS_GET_PIXEL, ARRAY_INDICES_1D
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

dimensions = [index1.naxis1, index1.naxis2]

indices = array_indices(dimensions, where1, /dimensions)

;Get coordinates for WHERE1 and first index
wcs1 = fitshead2wcs(index1)
coord = wcs_get_coord(wcs1, indices)

;Get corresponding pixels from second index
wcs2 = fitshead2wcs(index2)
pixels = wcs_get_pixel(wcs2, coord)

pixels = round(pixels)

;Round off pixels and give
if keyword_set(filter_dup) then begin
	str_pix = strjoin(trim(pixels), ',')
	unique = uniq(str_pix, sort(str_pix))
	if n_elements(unique) ne n_elements(pixels)/2 then begin 
		str_pix = str_pix[unique]
		pix = transpose((strsplit(str_pix, ',', /extract)).toarray(), [1,0])
		pixels = long(pix)
	endif
endif

;Now get 1-D subscripts

where2 = array_indices_1d([index2.naxis1,index2.naxis2], pixels)

if keyword_set(qstop) then stop

return, where2
end
