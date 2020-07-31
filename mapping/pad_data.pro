pro pad_data, ref_index, index, data, new_index, new_data, pad_value=pad_value

; ========================================================================================
;+
; NAME: 
;   PAD_DATA
;
; CATEGORY: 
;   Mapping
;
; PURPOSE: 
;   Pad (fill around the edges of) a data array so that it matches the dimensions on 
;   the sky of a reference index. Note that the pixel scales won't be the same, just 
;   the areas enclosed on the sky.
;
; INPUTS: 
;   REF_INDEX = FITS header structure to be matched to
;
;   INDEX = FITS header structure for data being padded
;
;   DATA = 2D data array to be padded
;
; OUTPUTS: 
;   NEW_INDEX = FITS header structure with modified pointing keywords for padded data
;
;   NEW_DATA = 2D padded array
;         
; KEYWORDS: 
;   PAD_VALUE = Fill value for new pixels in the padded array, default = 0
;
; EXAMPLES:
;   pad_data, ref_index, index, data, new_index, new_data
;
; NOTES:
;   Uses EXTEND_ARRAY to pad the data array, while the rest of the routine determines how 
;   much padding is needed and updates the pointing keywords.
;
; CALLS: 
;   FITSHEAD2WCS, WCS_GET_COORD, EXTEND_ARRAY
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

wcs1 = fitshead2wcs(ref_index)
wcs2 = fitshead2wcs(index)

ll_coord = wcs_get_coord(wcs1, [0,0])
ur_coord = wcs_get_coord(wcs1, [ref_index.naxis1, ref_index.naxis2]-1)

ll_pixel = wcs_get_pixel(wcs2, ll_coord)
ur_pixel = wcs_get_pixel(wcs2, ur_coord)

xdim = ceil(ur_pixel[0] - ll_pixel[0])
ydim = ceil(ur_pixel[1] - ll_pixel[1])

if xdim lt index.naxis1 OR ydim lt index.naxis2 then begin
	message, 'Oops, INDEX already has a larger FOV than REF_INDEX.', /info
	return
endif

;ensure that x and y dim match index.naxis1/2 in terms of even/odd 
if (index.naxis1 mod 2) eq 0 then xdim = xdim + (xdim mod 2) $
	else if (xdim mod 2) eq 0 then xdim = xdim + 1

if (index.naxis2 mod 2) eq 0 then ydim = ydim + (ydim mod 2) $
	else if (ydim mod 2) eq 0 then ydim = ydim + 1

;if the plate scales are the same to within floating precision, then double check that the 
;output image isn't off by 1 pixel to match and add/subtract an extra pixel if needed.
if float(index.cdelt1) eq float(ref_index.cdelt1) AND float(index.cdelt2) eq float(index.cdelt2) then begin
	if abs(xdim-ref_index.naxis1) le 1 then xdim = ref_index.naxis1 
	if abs(ydim-ref_index.naxis2) le 1 then ydim = ref_index.naxis2
endif 

new_data = extend_array(data, xdim, ydim, pad_value=pad_value)

new_index = index
new_index.naxis1 = xdim
new_index.naxis2 = ydim

new_index.crpix1 = (xdim/2.)+0.5
new_index.crpix2 = (ydim/2.)+0.5

return
end
