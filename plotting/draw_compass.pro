pro draw_compass, x0, y0, length, angle=angle, _extra=_extra, qstop=qstop

; ========================================================================================
;+
; NAME: 
;	DRAW_COMPASS
;
; CATEGORY: 
;	Plotting
;
; PURPOSE: 
;	Draw a compass on a plot.
;
; INPUTS: 
;	X0 = X position in data coordinates
;
;   Y0 = Y position in data coordinates
;
;   LENGTH = Length of arms in data coordinates
;
; OUTPUTS: 
;	No output, compass drawn on plot. 
;         
; KEYWORDS: 
;	ANGLE = Angle from vertical (if North is not up in the image)
;
; EXAMPLES:
;	draw_compass, 10, 10, 3, angle=90
;
; NOTES:
;	For solar-coordinates, so West is on the right if North is up. 
;
; CALLS: 
;   None
;
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================


dim = [!x.crange[1]-!x.crange[0],!y.crange[1]-!y.crange[0]]

if n_elements(length) eq 0 then length = dim[0]*0.05

xcoords = fltarr(5)
ycoords = fltarr(5)

if n_elements(x0) eq 0 then xcoords[0] = !x.crange[0] + dim[0]*0.3 else xcoords[0] = x0
if n_elements(y0) eq 0 then ycoords[0] = !y.crange[0] + dim[1]*0.3 else ycoords[0] = y0

if n_elements(angle) eq 0 then angle = 0

;end coordinate for North arrow
xcoords[1] = xcoords[0]+sin(angle/!radeg)*length
ycoords[1] = ycoords[0]+cos(angle/!radeg)*length

;end coordinate for West arrow
xcoords[2] = xcoords[0]+sin(angle/!radeg +!pi/2.)*length
ycoords[2] = ycoords[0]+cos(angle/!radeg +!pi/2.)*length

;extension beyond LENGTH to draw labels
offset = 1.1

;Coordinate for North label
xcoords[3] = xcoords[0]+sin(angle/!radeg)*length*offset
ycoords[3] = ycoords[0]+cos(angle/!radeg)*length*offset

;Coordinate for West label
xcoords[4] = xcoords[0]+sin(angle/!radeg +!pi/2.)*length*offset
ycoords[4] = ycoords[0]+cos(angle/!radeg +!pi/2.)*length*offset

;buffer to move coordinates to bottom left corner
;midpoint = [mean(xcoords[1:2]), mean(ycoords[1:2])]
;buffer = 1.5*length - (midpoint - [!x.crange[0],!y.crange[0]])

buffer = fltarr(2) + 1.2*length
if min(xcoords) eq xcoords[0] then buffer[0] = buffer[0]/2.0
if min(ycoords) eq ycoords[0] then buffer[1] = buffer[1]/2.0

buffer = buffer - ([min(xcoords),min(ycoords)] - [!x.crange[0],!y.crange[0]])

xcoords = xcoords+buffer[0]
ycoords = ycoords+buffer[1]

if not keyword_set(hsize) then $
	if !d.name eq 'X' then hsize=8 else hsize=200

;draw arrows
arrow, xcoords[0], ycoords[0], xcoords[1], ycoords[1], /data, /solid, hsize=hsize, _extra=_extra
arrow, xcoords[0], ycoords[0], xcoords[2], ycoords[2], /data, /solid, hsize=hsize, _extra=_extra

xyouts, xcoords[3], ycoords[3], 'N', alignment=0.5, orientation=-angle, _extra=_extra
xyouts, xcoords[4], ycoords[4], 'W', alignment=0.5, orientation=-angle-90, _extra=_extra

if keyword_set(qstop) then stop

return
end
