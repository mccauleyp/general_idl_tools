function coords_to_map_data, map, coords, missing=missing

; ========================================================================================
;+
; NAME: 
;	COORDS_TO_MAP_DATA
;
; CATEGORY: 
;	Mappping
;
; PURPOSE: 
;	Given a SolarSoft map and coordinates in physical units (arcsec from Sun-center), 
;   return the data from those coordinates.
;
; INPUTS: 
;	MAP = Struct, SolarSoft map structure
;
;   COORDS = [2,N] array of coordinates
;
; OUTPUTS: 
;	RETURN = Array of data values of same type as the map data array
;         
; KEYWORDS: 
;   MISSING = Value to assign to coordinates that aren't on the map, default = 0
;	
;
; EXAMPLES:
;	data = coords_to_map_data(map, [x,y])
;
; CALLS: 
;   VALID_MAP, CONVERT_MAP_UNITS, MAP2WCS, WCS_GET_PIXEL, ARRAY_INDICES_1D
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if valid_map(map) ne 1 then begin
	message, 'Oops, MAP input should be a map structure (valid_map(map) = 0)', /info
	return, -1
endif

if n_elements(coords) ne 2 AND n_elements(size(coords, /dim)) ne 2 then begin
	message, 'Oops, COORDS should be 2D x,y coordinates in arcsec', /info
	return, -1
endif 

amap = map
convert_map_units, amap, 'arcsec'

map2wcs, amap, wcs

pixels = wcs_get_pixel(wcs, coords)

pixels = round(pixels)

want = array_indices_1d(amap.data, pixels)

data = amap.data[want]

return, data
end
