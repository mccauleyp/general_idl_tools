function baseline_image, images, style=style, missing=missing, median=median, $
			included=included, excluded=excluded, ind_missing=ind_missing

; ========================================================================================
;+
; NAME: 
;   BASELINE_IMAGE
;
; CATEGORY: 
;   Image Processing
;
; PURPOSE: 
;   Given an image cube, return an image that represents the "baseline" (i.e. background)
;   state. This is determined by examining the total intensity in each image and running 
;   the McBASELINE procedure to find the background total intensity level. The baseline
;   image is then comprised of the median pixel intensity across images with total 
;   intensities beneath 2-sigma above the baseline level. 
;
; INPUTS: 
;   IMAGES = (3D Array) [Nx,Ny,Nimgs] Image stack
;
; OUTPUTS: 
;   RETURN = (2D Array) [Nx,Ny] Baseline / background image
;         
; KEYWORDS: 
;   STYLE = (Boolean) default = 0. If this is set to 1, instead of the procedure 
;           described above, the value of each pixel in RETURN represents the baseline
;           value determined pixel-by-pixel. This will likely return a noisier image but 
;           may be more appropriate for certain applications. 
;
;   MISSING = (Int or Float) Value within IMAGES that will be flagged as "missing" pixels 
;             and not included in the baseline procedure. 
;
;   MEDIAN = (Boolean) default = 1. Set to 0 to use the mean instead of median. 
;
;   INCLUDED = (Long Array) Indices from the third axis of IMAGES that correspond to 
;              the indexes within IMAGES that were used to construct the baseline image.
;
;   EXCLUDE = (Long Array) Same as above but for images not used for baseline image.
;
;   IND_MISSING = (Long Array) 1D indices of positions with value = MISSING
;
; NOTES:
;   I used this routine primarily to construct background images out of cubes that were 
;   highly variable in an automatic, algorithmic fashion. See the header for McBASELINE
;   for more info on how the baselining procedure works. 
;
; CALLS: 
;   McBASELINE, DEFAULT, PROGRESS_BAR
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, style, 0
default, median, 1
default, missing, 0

sz = size(images, /dim)
if n_elements(sz) ne 3 then begin
	message, 'Oops, input IMAGES should be a 3D array [Nx,Ny,Nimgs]', /info
	return, -1
endif

case style of
	0: begin
	
		datatot = total(total(images, 1, /double), 1, /double) 
		bline = mcbaseline(datatot, median=median, missing=missing, excluded=excluded, included=included, ind_missing=ind_missing)
		
		if included[0] eq -1 then begin

			message, 'WARNING: No images INCLUDED by MCBASELINE. Blank image returned.', /info
			img_out = fltarr(sz[0], sz[1])
		
		endif else begin 
		
			if keyword_set(median) then img_out = median(images[*,*,included], dim=3) $
				else img_out = mean(images[*,*,included], dim=3)
		
		endelse
		
	end
	1: begin

		want = where(images[*,*,0] ge min(images[*,*,0]), count)
		ind = array_indices(images[*,*,0], want)

		img_out = fltarr(sz[0], sz[1])

		for i=0, count-1 do begin

			pixel_series = reform(images[ind[0,i],ind[1,i],*])
			img_out[ind[0,i],ind[1,i]] = mcbaseline(pixel_series, median=median, missing=missing)

			progress_bar, i, count-1

		endfor	
		
	end
endcase

return, img_out
end
