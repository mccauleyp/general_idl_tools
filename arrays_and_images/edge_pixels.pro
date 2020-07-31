function edge_pixels, image, border=border

; ========================================================================================
;+
; NAME: 
;	EDGE_PIXELS
;
; CATEGORY: 
;	Array Operations
;
; PURPOSE: 
;	Return the 1D subscripts of pixels along the border of a 2D array. 
;
; INPUTS: 
;	IMAGE = 2D array 
;
; OUTPUTS: 
;	RETURN = 1D subscripts, as if returned from WHERE function
;         
; KEYWORDS: 
;	BORDER = Thickness of border in pixels, default = 1
;
; EXAMPLES:
;	arr = bytarr(256,256)
;   edge = edge_pixels(arr, border=2)
;   arr[edge] = 1
;   plot_image, arr
;
; NOTES:
;	
;
; CALLS: 
;   None
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================


if n_elements(border) eq 0 then border = 1
border = border >1

sz = size(image, /dim)
yy = indgen(sz[0]) ## (1. + fltarr(sz[1])) 
xx = (1. + fltarr(sz[0])) ## indgen(sz[1])

edge = where(xx gt max(xx)-border OR $
			 xx lt min(xx)+border OR $
			 yy gt max(yy)-border OR $
			 yy lt min(yy)+border)

return, edge
end
