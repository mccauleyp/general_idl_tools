function snr_img, img, sig

; ========================================================================================
;+
; NAME: 
;   SNR_IMG
;
; CATEGORY: 
;   Image Processing
;
; PURPOSE: 
;   Return an image for which each pixel is the signal-to-noise ratio of the corresponding 
;   value in the input image
;
; INPUTS: 
;   IMG = (Float Array) 2D image array
;
; OUTPUTS: 
;   RETURN = (Float Array) Each element is the SNR of the corresponding pixel in IMG
;         
;   SIG = (Float) Noise level, determined from the standard deviation of pixel values 
;         along all 4 edges of IMG
;
; CALLS: 
;   EDGE_PIXELS
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


sz = size(img, /dim)

if n_elements(sz) eq 3 then nimgs = sz[2] else nimgs = 1

snr_img = dblarr(sz)
if nimgs eq 1 then sig = 0. else sig = dblarr(nimgs)

for i=0, nimgs-1 do begin

	this_img = img[*,*,i]
	this_sig = stddev(this_img[edge_pixels(this_img)], /double)

	if finite(this_sig) eq 0 then stop

	if this_sig eq 0 then begin
		message, 'WARNING: 0 stddev found, returning original image.', /info
		snr_img[*,*,i] = this_img
	endif else begin
		snr_img[*,*,i] = this_img/this_sig
		sig[i] = this_sig
	endelse

endfor

return, snr_img
end
