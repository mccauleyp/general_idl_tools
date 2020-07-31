function cutout_map, index, data, cutout

; ========================================================================================
;+
; NAME: 
;	CUTOUT_MAP
;
; CATEGORY: 
;	Mapping
;
; PURPOSE: 
;	Generate a map from a cutout portion of an image
;
; INPUTS: 
;	INDEX = FITS header structure associated with DATA
;
;   DATA = 2D data array that is already cropped to cutout region (image)
;
;   CUTOUT = [x1,x2,y1,y2] cutout box in pixels 
;
; OUTPUTS: 
;	RETURN = SolarSoft map structure corresponding to cutout box region
;         
; KEYWORDS: 
;	None
;
; EXAMPLES:
;	submap = cutout_map(index, data, [x1,x2,y1,y2])
;
; NOTES:
;	Useful if the you already have the cutout box in pixels, otherwise you might be
;   better off using the SUB_MAP function on its own instead.
;
; CALLS: 
;   FITSHEAD2WCS, WCS2MAP, WCS_GET_COORD, SUB_MAP, MAP2WCS, WCS2MAP
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

wcs = fitshead2wcs(index)
wcs2map, bytarr(index.naxis1,index.naxis2), wcs, map

lower_left = [cutout[0], cutout[2]]
upper_right = [cutout[1], cutout[3]]

lower_left_coord = wcs_get_coord(wcs, lower_left)
upper_right_coord = wcs_get_coord(wcs, upper_right)

xrange = [lower_left_coord[0],upper_right_coord[0]]
yrange = [lower_left_coord[1],upper_right_coord[1]]

sub_map, map, smap, xrange=xrange, yrange=yrange

map2wcs, smap, swcs

sz = size(smap.data, /dim)
if sz[0] ne (cutout[1]-cutout[0]+1) OR sz[1] ne (cutout[3]-cutout[2]+1) then stop

map2wcs, smap, cwcs
wcs2map, data, cwcs, cmap

return, cmap
end
