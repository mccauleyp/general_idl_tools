pro correl_portion, files, cutout, offsets, cuts, aligned, thresh=thresh

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	CORREL_PORTION
;
; CATEGORY: 
;	Image Processing
;
; PURPOSE: 
;	Align a sequences of JPEG2000 images using cross correlation on a portion of the image.
;
; CALLING SEQUENCE:
;	correl_portion, files, cutout, offsets, cuts, aligned [,thresh=thresh]
;
; INPUTS: 
;	FILES - [Mandatory] (String Array)
;			String array of paths to JPEG2000 images
;	CUTOUT - [Mandatory] (Integer Array)
;			[x1,x2,y1,y2] pixels that define portion of image to use for the correlation
;
; OUTPUTS: 
;	OFFSETS - [Mandatory] (Float Array)
;			Pixel offsets with respect to the first image. [x, y, Nimgs]
;	CUTS - [Optional] (Byte Array)
;			Cutout image array, [Nx, Ny, Nimgs]
;	ALIGNED - [Optional] (Byte Array)
;			Aligned image array, [Nx, Ny, Nimgs]
;      
; KEYWORDS: 
;	THRESH - [Optional] (Integer)
;			Value between 0 and 255 that will be used to threshold the image before the 
;			cross correlation. The default is 0 (no threshold)
;
; EXAMPLES:
;	files = file_search(dir+'*.jp2')
;	correl_portion, files, [0, 200, 0, 200], offsets, cuts, aligned, thresh=100
;
; NOTES:
;	Not a particularly flexible routine. Don't even remember what I used it for...
;
; MODIFICATION HISTORY: 
;	2014/01/30 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

dim = [cutout[1]-cutout[0]+1, cutout[3]-cutout[2]+1]
cuts = bytarr(dim[0], dim[1], n_elements(files))

for i=0, n_elements(files)-1 do begin
	print, i
	jp2_read, files[i], in, da
	if keyword_set(thresh) then cuts[*,*,i] = da[cutout[0]:cutout[1], cutout[2]:cutout[3]] > thresh $
	else cuts[*,*,i] = da[cutout[0]:cutout[1], cutout[2]:cutout[3]]
endfor

align_cube_correl, cuts, aligned, offsets=offsets

window, xs=dim[0], ys=dim[1]

for i=0, n_elements(files)-1 do begin
	tv, bytscl(aligned[*,*,i])
	wait, 0.01
endfor

for i=0, n_elements(files)-1 do begin
	tv, bytscl(shift_img(cuts[*,*,i], offsets[*,i], missing=0))
	wait, 0.01
endfor

return
end
