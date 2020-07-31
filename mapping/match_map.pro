function match_map, map1, map2, img_out=img_out, default_aia=default_aia

; ========================================================================================
;+
; NAME: 
;   MATCH_MAP
;
; CATEGORY: 
;   Mapping
;
; PURPOSE: 
;   Scale the units and clip the field-of-view of MAP2 to match that of MAP1. 
;
; INPUTS: 
;   MAP1 = SolarSoft map structure (reference map)
;
;   MAP2 = SolarSoft map structure (map to modify)
;
; OUTPUTS: 
;   RETURN = MAP2 scaled to the same units, resolution, and FOV of MAP1 so their .data
;           tags match exactly
;         
; KEYWORDS: 
;   IMG_OUT = 2D array containing just the scaled MAP2.data contents
;
;   DEFAULT_AIA = Boolean, set so that MAP1 corresponds to a standard SDO/AIA image. The 
;                 MAP1 input still needs to be supplied, but can be any dummy variable.
; 
;
; CALLS: 
;   GRID_MAP
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

;Unit conversion to get from rsun per pixel to arcsec
;rsun_km = 696342.
;km_arcsec = (*fit[1]).km_arcsec
;decay_platscl = decay_map.dx ;rsun per pixel
;decay_arcsec = decay_platscl*rsun_km/km_arcsec ;arcsec per pixel

if keyword_set(default_aia) then begin
	dummy = bytarr(4096,4096)
	map1={data:bytarr(4096,4096),xc:0.0,yc:0.0,dx:0.6,dy:0.6,roll_angle:0.0,$
		roll_center:[0.0,0.0],time:map2.time,xunits:'arcsecs',yunits:'arcsecs',$
		id:'Blank AIA Map'}
endif

if strmid(strlowcase(map1.xunits),0,6) ne 'arcsec' OR strmid(strlowcase(map1.xunits),0,6) ne 'arcsec' then begin
	message, 'Oops, units for both maps must be arcsec', /info
	return, -1
endif

map1_dim = size(map1.data, /dim)
map1_crpix = float(map1_dim)/2 +0.5

scaled_map = grid_map(map2, space=[map1.dx,map1.dy])

map_size = size(scaled_map.data, /dim)

xpix = (findgen(map_size[0])-(map_size[1]/2-0.5))
ypix = (findgen(map_size[1])-(map_size[1]/2-0.5))

xwant = where(xpix gt -1*map1_crpix[0] AND xpix le map1_crpix[0])
ywant = where(ypix gt -1*map1_crpix[1] AND xpix le map1_crpix[1])

if n_elements(xwant) eq map1_dim[0]+1 then xwant = xwant[0:map1_dim[0]-1]
if n_elements(ywant) eq map1_dim[1]+1 then ywant = ywant[0:map1_dim[1]-1]

if n_elements(xwant) ne map1_dim[0] OR n_elements(ywant) ne map1_dim[1] then begin
	message, 'Oops, MAP2.data is not large enough to be clipped to MAP1.data grid. Returning unclipped array, may need debugging.', /info
	img_out = scaled_map.data
endif else begin
	img_out = scaled_map.data[xwant[0]:xwant[n_elements(xwant)-1],ywant[0]:ywant[n_elements(ywant)-1]]
endelse

return, scaled_map
end
