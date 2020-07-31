pro caption, text, x, y, left=left, right=right, middle=middle, $
				lower=lower, upper=upper, $
				alignment=alignment, xnudge=xnudge, ynudge=ynudge, $
				coord=coord, nodraw=nodraw, background=background, $
				_extra=_extra, top=top, bottom=bottom

; ========================================================================================
;+
; NAME: 
;	CAPTION
;
; CATEGORY: 
;	Plotting
;
; PURPOSE: 
;	An easier to way to place captions on plots than using XYOUTS. Use keywords for a 
;   decent default positioning and the nudge keywords to slightly adjust if needed. 
;
; INPUTS: 
;	TEXT = String for caption
;
;   X = Optional X position (use keywords instead)
;
;   Y = Optional Y position (use keywords instead)
;
; OUTPUTS: 
;	No output, caption drawn on plot
;         
; KEYWORDS: 
;	LEFT = Boolean, caption on left side
;
;   RIGHT = Boolean, caption on right side
;
;   MIDDLE = Boolean, caption in the middle
;
;   UPPER = Boolean, caption on top
;
;   TOP = Boolean, alternative to /UPPER because
;
;   LOWER = Boolean, caption on bottom
;
;   BOTTOM = Boolean, alternative to /LOWER
;
;   ALIGNMENT = Float, 0 = left justified, 0.5 = middle, 1 = right. Defaults 0 if 
;               /left, 0.5 if /middle, 1 if /right
;
;   XNUDGE = Float, amount to nudge from default X position in data coordinates
;
;   YNUDGE = Float, amount to nudge from default Y position in data coordinates
;
;   COORD = Optional output, coordinate where caption is drawn
;
;   NODRAW = Don't draw the caption (perhaps you just want COORD)
;
;   BACKGROUND = Boolean, write on top of a black or white box, depending on plot BG
;
;   _EXTRA = Inherits keywords from XYOUTS, etc
;
;
; EXAMPLES:
;
;   plot, indgen(10), indgen(10)
;   caption, 'Hey!', /upper, /left
;	
; CALLS: 
;   TAG_EXIST from SolarSoft
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if keyword_set(left) then x = 0.05
if keyword_set(right) then x = -0.05
if keyword_set(middle) then x = 0.5 

if keyword_set(top) then upper=1
if keyword_set(bottom) then lower=1

if keyword_set(lower) then y = 0.06
if keyword_set(upper) then y = -0.08

if n_elements(x) eq 0 then x=0.05
if n_elements(y) eq 0 then y=0.06

if keyword_set(xnudge) then x = x+xnudge
if keyword_set(ynudge) then y = y+ynudge

if not keyword_set(alignment) then begin 
	if keyword_set(middle) then alignment = 0.5 else begin
		if x lt 0 then alignment = 1 else alignment = 0
	endelse
endif

xdim = !x.crange[1]-!x.crange[0]
ydim = !y.crange[1]-!y.crange[0]

if x lt 0 then xcoord = !x.crange[1] + xdim*x $
	else xcoord = !x.crange[0] + xdim*x
	
if y lt 0 then ycoord = !y.crange[1] + ydim*y $
	else ycoord = !y.crange[0] + ydim*y

coord = [xcoord,ycoord]		

if not keyword_set(nodraw) then begin

	if keyword_set(background) then begin
	
		if tag_exist(_extra, 'color') then begin
			if _extra.color eq 0 then color = 255
			if _extra.color eq 255 then color = 0
		endif else begin
			color = !p.background
		endelse	
	
		width = xdim*background[0]
		height = ydim*background[1]
		
		x = coord[0] + [-1.*width*alignment, (1.-alignment)*width]
		y = [coord[1], coord[1]+height]
		
		ad = [0.05,0.18]
		if alignment eq 0 then ad[0] = ad[0]*(-1)
		if alignment eq 0.5 then ad[0] = 0
		
		x = x+width*ad[0]
		y = y-height*ad[1]
		
		pos = strpos(text, '!C')
		nlines = 1
		while pos ne -1 do begin
			nlines = nlines+1
			pos = strpos(strmid(text, pos+2, strlen(text)), '!C')
		endwhile
		
		if nlines gt 1 then begin
			ybdim = y[1]-y[0]
			y = y - (ybdim/nlines)*.75
		endif
		
		polyfill, [x[0],x[1],x[1],x[0]], [y[0],y[0],y[1],y[1]], /data, color=color
	
	endif
	
	xyouts, coord[0], coord[1], text, alignment=alignment, _extra=_extra, width=width

	
endif
						  
return
end
