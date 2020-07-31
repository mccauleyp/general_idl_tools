function hanning_image, orig_image, alpha=alpha, hamming=hamming

; ========================================================================================
;+
; NAME: 
;   HANNING_IMAGE
;
; CATEGORY: 
;   Array Operations, Image Processing
;
; PURPOSE: 
;   Applying a Hanning filter to suppress noise in an image
;
; INPUTS: 
;   ORIG_IMAGE = 2D image array 
;
; OUTPUTS: 
;   RETURN = 2D filtered array 
;         
; KEYWORDS: 
;   ALPHA = Keyword for HANNING funcition, default = 0.5
;
;   HAMMING = Sets ALPHA = 0.54
;
; EXAMPLES:
;   filtered = hanning_image(img, /hamming)
;
; NOTES:
;   Taken from IDL help page...
;   http://www.harrisgeospatial.com/docs/RemovingNoise.html
;
; CALLS: 
;
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================


if keyword_set(hamming) then alpha = 0.54

orig_imageSize = size(orig_image, /dimensions)

 ; Determine the forward Fourier transformation of the image
  transform = SHIFT(FFT(orig_image), (orig_imageSize[0]/2), $
    (orig_imageSize[1]/2))
   
  ; Apply a Hanning mask to filter out the noise
  mask = HANNING(orig_imageSize[0], orig_imageSize[1], alpha=alpha)
  maskedTransform = transform*mask
   
  ; Apply the inverse transformation to the masked frequency domain image
  inverseTransform = FFT(SHIFT(maskedTransform, $
    (orig_imageSize[0]/2), (orig_imageSize[1]/2)), /INVERSE)
   
  inverseImage = REAL_PART(inverseTransform)

return, inverseImage 
end
