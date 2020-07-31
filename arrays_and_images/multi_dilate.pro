function multi_dilate, image, structure, _extra=_extra, niter=niter

; ========================================================================================
;+
; NAME: 
;   MULTI_DILATE
;
; CATEGORY: 
;   Array Operations, Image Processing
;
; PURPOSE: 
;   Simple wrapper for DILATE to perform multiple dilations with the same kernel
;
; INPUTS: 
;   IMAGE = 2D array (image) to be dilated
;
;   STRUCTURE = Dilation kernel
;
; OUTPUTS: 
;   RETURN = 2D 
;         
; KEYWORDS: 
;   NITER = Int, number of dilations (default = 1)
;
;   _EXTRA = keyword inheritance for DILATE
;
; NOTES:
;   See https://www.harrisgeospatial.com/docs/DILATE.html
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


if not keyword_set(niter) then niter = 1

dilated = image
for i=0, niter-1 do begin

	dilated = dilate(dilated, structure, _extra=_extra)

endfor 


return, dilated
end
