function ring_wrapper, index, data, rsun=rsun, _extra=_extra

; ========================================================================================
;+
; NAME: 
;   RING_WRAPPER
;
; CATEGORY: 
;   Mapping, Array Operations
;
; PURPOSE: 
;   Combine PIXEL_MAP, SORT_INTO_RINGS, and RING_METRICS to generate a pixel map, sort it
;   into rings, and return various values corresponding to each ring. See headers for 
;   the subroutines for more details. 
;
; INPUTS: 
;   INDEX = (Structure) FITS header structure for DATA
;
;   DATA = (2D Array) Data array (image)
;
; OUTPUTS: 
;   RETURN = (Structure) A single structure that packages together DATA, the output from
;            PIXEL_MAP, the output from SORT_INTO_RINGS, and the output from RING_METRICS.
;            See headers for those routines for more details. 
;
; KEYWORDS: 
;   RSUN = (Boolean) Default=1, which will yield units in solar radii. Set to 0 for units 
;          in arcsec. 
;
;   _EXTRA = Inherits all subroutine keywords. See headers for more details on the options, 
;            such as the number of rings, height ranges, etc. 
;
; CALLS: 
;   DEFAULT, VALID_MAP, PIXEL_MAP, SORT_INTO_RINGS, RING_METRICS
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

default, rsun, 1

if valid_map(index) eq 1 then data = index.data

pmap = pixel_map(index, rsun=rsun)

rsort = sort_into_rings(pmap, _extra=_extra)

metrics = ring_metrics(rsort, data)

output = {data:data, maps:pmap, rings:rsort, metrics:metrics}

return, output
end


