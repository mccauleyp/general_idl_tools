pro convert_map_units, map, units_out, xrange=xrange, yrange=yrange, $
	unit_conversion=unit_conversion, xrout=xrout, yrout=yrout, quiet=quiet

; ========================================================================================
;+
; NAME: 
;   CONVERT_MAP_UNITS
;
; CATEGORY: 
;   Mapping
;
; PURPOSE: 
;   Convert the units of a SolarSoft map structure from arcsec to rsun or vice versa
;
; INPUTS: 
;   MAP = (Structure) SolarSoft map 
;
;   UNITS_OUT = (String) 'rsun' or 'arcsec'
;
; OUTPUTS: 
;   MAP = (Structure) The map input will be modified in-place
;         
; KEYWORDS: 
;   XRANGE, YRANGE = (Float Array) Input keywords containing the X/Y ranges in the native
;                    map units for some particular subregion of MAP that you're 
;                    interested in.
;
;   XROUT, YROUT = (Float Array) Output keywords containing X/YRANGE in the new units.
;
;   UNIT_CONVERSION = (Float) Unit conversion factor between the units. This changes 
;                     slightly as the Sun's position with respect to Earth changes.
;
;   QUIET = (Boolean) Set to suppress messages.
;
; NOTES:
;   GET_MAP_PROP, REP_PROP, PB0R, ANYTIM, TAG_EXIST, DEFAULT
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, quiet, 1

if n_elements(units_out) eq 0 then units_out = 'arcsecs'
if units_out eq 'arcsec' then units_out = 'arcsecs' ;add 's' because i'll keep doing this... 

unit_conversion = 1.

allowed = ['arcsecs','rsun']
want = where(units_out eq allowed, count)
if count eq 0 then begin
	message, 'Oops, only units supported: '+strjoin(allowed), /info
	return
endif

units = [trim(get_map_prop(map, /xunits, /quiet)), $
		trim(get_map_prop(map, /yunits, /quiet)), $
		trim(get_map_prop(map, /units, /quiet))]
time = get_map_prop(map, /time)

dx = get_map_prop(map, 'dx')
dy = get_map_prop(map, 'dy')
xc = get_map_prop(map, 'xc')
yc = get_map_prop(map, 'yc')
if tag_exist(map, 'rsun') then rsun = get_map_prop(map, 'rsun')

want = where(units eq '-1', count, complement=complement)

if count eq 3 then begin
	message, 'Oops, XUNITS, YUNITS, and UNITS not defined for input MAP.', /info
	return;, -1
endif

units_in = units[complement[0]]

if units_in eq 'arcsec' then units_in = 'arcsecs'

if units[0] ne '-1' then rep_prop, map, xunits=units_out
if units[1] ne '-1' then rep_prop, map, yunits=units_out
if units[2] ne '-1' then rep_prop, map, units=units_out

if strlowcase(strmid(units_in, 0, 6)) eq strlowcase(strmid(units_out, 0, 6)) then begin
	if not keyword_set(quiet) then message, 'UNITS_IN ('+units_in+') = UNITS_OUT ('+units_out+'), so no change.', /info
	unit_converson = 1.
	if n_elements(xrange) gt 0 then xrout = xrange*unit_conversion
	if n_elements(yrange) gt 0 then yrout = yrange*unit_conversion	
	return
endif

sun_angles = pb0r(anytim(time, /ccsds), /earth, l0=l0, /arcsec)
rsun_arcsec = sun_angles[2]

case strlowcase(units_in) of
	'rsun': begin		
		case units_out of
			'arcsecs': unit_conversion = rsun_arcsec
			else: begin
				message, 'Unit conversion to '+units_out+' not supported. Sorry!', /info
				return;, -1
			end
		endcase
	end
	'arcsecs': begin
		case units_out of
			'rsun': unit_conversion = 1./rsun_arcsec
			else: begin
				message, 'Unit conversion to '+units_out+' not supported. Sorry!', /info
				return;, -1
			end
		endcase	
	end
	else: begin
		message, 'Unit conversion from '+units_in+' not supported. Sorry!', /info
		return;, -1
	end
endcase

rep_prop, map, dx=dx*unit_conversion
rep_prop, map, dy=dy*unit_conversion
rep_prop, map, xc=xc*unit_conversion
rep_prop, map, yc=yc*unit_conversion
if tag_exist(map, 'rsun') then rep_prop, map, rsun=rsun*unit_conversion

if n_elements(xrange) gt 0 then xrout = xrange*unit_conversion
if n_elements(yrange) gt 0 then yrout = yrange*unit_conversion

	
return;, map
end
