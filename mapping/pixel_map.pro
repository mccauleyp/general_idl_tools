function pixel_map, index, rsun=rsun, _extra=_extra

; ========================================================================================
;+
; NAME: 
;   PIXEL_MAP
;
; CATEGORY: 
;   Mapping
;
; PURPOSE: 
;   Generate a structure containing the X, Y, and radial coordinates of every pixel in 
;   a solar image. 
;
; INPUTS: 
;   INDEX = (Structure) FITS header
;
; OUTPUTS: 
;   RETURN = (Structure) Contains the following tags:
;            {x:xx, y:yy, r:rr, units1:units, psi:psi, units2:'deg'}
;            Where x, r, y, and psi are 2D arrays containing the cartesian or radial 
;            coordinate values for each pixel. The units for x, y, and r will be 
;            arcsec from Sun-center unless the RSUN keyword is set, in which case they'll
;            be in solar radii
;   
;         
; KEYWORDS: 
;   RSUN = (Boolean) Set for spatial coordinates in solar radii instead of arcsec
;
; EXAMPLES:
;   pixels = pixel_map(index, /rsun)
;   plot_image, pixel_map.r
;
; NOTES:
;   Uses the World Coordinate System (WCS) codes in SolarSoft
;
; CALLS: 
;   VALID_MAP, MAP2WCS, FITSHEAD2WCS, WCS_GET_COORD, WCS_CONVERT_FROM_COORD, PB0R
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


if size(index, /tname) ne 'STRUCT' then begin
	message, 'Oops, input INDEX should be a structure (FITS header or map)', /info
	return, -1
endif

if valid_map(index) eq 1 then map2wcs, index, wcs $
	else wcs = fitshead2wcs(index)

coord = wcs_get_coord(wcs)

;psi = counter clockwise angle around circle (north = 0)
;rho = angular distance from sun-center 
wcs_convert_from_coord, wcs, coord, 'HPR', psi, rho, /zero_center, /pos_long

xx = reform(coord[0,*,*])
yy = reform(coord[1,*,*])

rr = sqrt(xx^2 + yy^2)

units = wcs.cunit[0]

if keyword_set(rsun) AND strlowcase(wcs.cunit[0]) ne 'rsun' then begin 
	if strlowcase(wcs.cunit[0]) ne 'arcsec' then begin
		message, 'Unable to convert units of '+wcs.cunit[0]+' to solar radii.', /info
	endif else begin
		sun_angles = pb0r(wcs.time.observ_date, /arcsec)
		xx = xx / sun_angles[2]
		yy = yy / sun_angles[2]
		rr = rr / sun_angles[2]
		units = 'rsun'
	endelse
endif

output = {x:xx, y:yy, r:rr, units1:units, psi:psi, units2:'deg'}

return, output
end
