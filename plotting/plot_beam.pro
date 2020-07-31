pro plot_beam, index, xc, yc, $
			left=left, right=right, upper=upper, lower=lower, $
			offset=offset, edge_dist=edge_dist, _extra=_extra, $
			size_coeff=size_coeff, unit_conversion=unit_conversion, north=north
		
; ========================================================================================
;+
; NAME: 
;   PLOT_BEAM
;
; CATEGORY: 
;   Plotting
;
; PURPOSE: 
;   Put a radio telescope's primary beam in the corner of another plot or image. 
;
; INPUTS: 
;   INDEX = (Structure) FITS header struct containing the BMAJ, BMIN, and BPA keywords.
;           Can be any structure as long as it has those 3 tags.
;
;   XC, YC = (Floats) Optional inputs to explicitly specific where to center the beam 
;            in data coordinates.
;
; OUTPUTS: 
;   None, beam draw on plot
;         
; KEYWORDS: 
;   LEFT = (Boolean) Set to plot on left (default=1)
;
;   LOWER = (Boolean) Set to plot at bottom (default=1)
;
;   UPPER = (Boolean) Set to plot at top
;
;   RIGHT = (Boolean) Set to plot on right
;
;   OFFSET = (Int) Default=2. The beam will be offset this amount from the edge multiplied 
;            by the major axis length
;
;   EDGE_DIST = (Float) Set to explicitly set the distance from the edge instead of using 
;               the OFFSET keyword or its default value
;
;   SIZE_COEFF = (Float) Set to modify the overall beam size by a multiplicative factor
;
;   UNIT_CONVERSION = (Float) Set to the appropriate unit conversion factor if the 
;                     units of INDEX (i.e. the beam) are not the same as the plot you're 
;                     overlaying it onto (for example if the beam is in arcsec but the 
;                     plot is in solar radii)
;
;   NORTH = (Boolean) Default = 1. This assumes that the angle (INDEX.BPA) is measured
;           from the vertical, which is usually the case. Set to 0 if you mean it to be 
;           measured from the horizontal instead
;
;   _EXTRA = Keyword inheritance for TVELLIPSE. You can use this to adjust the thickness 
;            of the lines (e.g. thick=6) or produce a filled ellipse (e.g. fill=1)
;
; NOTES:
;   See _EXTRA keyword notes for info in adjusting how the beam appears. 
;
; CALLS: 
;   DEFAULT, TVELLIPSE
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================
		
			
default, north, 1

default, unit_conversion, 1.

if (n_elements(xc) + n_elements(yc)) lt 2 then begin
	
	xr = !x.crange
	yr = !y.crange

	if not keyword_set(left) AND not keyword_set(right) then left=1
	if not keyword_set(upper) and not keyword_set(lower) then lower=1
	if not keyword_set(offset) then offset = 2.
	
	default, edge_dist, (sqrt(2)*(index.bmaj/2.))*offset*unit_conversion

	if keyword_set(left) then xc = !x.crange[0]+edge_dist else xc = !x.crange[1]-edge_dist
	if keyword_set(lower) then yc = !y.crange[0]+edge_dist else yc = !y.crange[1]-edge_dist

endif

sz = [index.bmaj/2., index.bmin/2.]*unit_conversion
if keyword_set(size_coeff) then sz = sz*size_coeff

if keyword_set(north) then ang = index.bpa+90.

tvellipse, sz[0], sz[1], xc, yc, ang, /data, _extra=_extra

return
end
