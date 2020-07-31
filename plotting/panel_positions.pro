function panel_positions, npanels, x1=x1, y1=y1, xn=xn, yn=yn, xgap=xgap, ygap=ygap, $
						xfrac=xfrac, yfrac=yfrac, test=test, _extra=_extra, book=book, $
						no_ticks=no_ticks

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	PANEL_POSITIONS
;
; CATEGORY: 
;	Plotting
;
; PURPOSE: 
;	Return position arrays for multi-panel plot elements.
;
; CALLING SEQUENCE:
;	positions = panel_positions(npanels, x1=float, y1=float, xn=float, yn=float, $
;								xgap=float array, ygap=float array, xfrac=float array, $
;								yfrac=float array, test=boolean or integer array)
;
; INPUTS: 
;	NPANELS = Integer Array [Nx, Ny]. [Number of X panels, Number of Y panels]. If a 
;			  single integer is passed, it's assumed to be the number of X panels with 
;			  one Y panel. 
;
;			  Or String Array. See Notes
;
; OUTPUTS: 
;	RETURN = Float Array. [X1, Y1, X2, Y2, Panel#]. Panel positions that can be directly 
;			 passed to any plotting routine that accepts the POSITION keyword. Note that 
;			 all positions are in normalized coordinates (0 to 1). 
;         
; KEYWORDS: 
;	X1 = Float, default = 0.10. X position of leftmost panel edge(s). 
;	
;	Y1 = Float, default = 0.10. Y position of bottom panel edge(s).
;
;	XN = Float, default = 0.98. X position of rightmost panel edge(s). 
;
;	YN = Float, default = 0.98. Y position of top panel edges(s).
;
;	XGAP = Float or Float Array. Default = 0.1. Horizontal X gap between panels. This can 
;		   be supplied either as a single value or as an array for variable gaps between 
;		   horizontal panels. If passed as an array, the number of elements should equal 
;		   the number of X panels minus 1 (i.e. the number of gaps).
;	
;	YGAP = Float or Float Array. Default = 0.1. Vertical Y gap between panels. Behaves the 
;		   same as XGAP, see above. 
;
;	XFRAC = Float Array. Fractional horizontal extents of each panel. By default, each 
;			panel will have the same size. Set this keyword if you want the panels in 
;			one row to be larger (longer) than than adjacent rows. For example, setting
;			XFRAC = [0.2,0.8] will make the the left and right panels take up 20% and 80% 
;			of the available plot area, respectively. The total of XFRAC must equal 1. 
;
;	YFRAC = Float Array. Fractional vertical extents of each panel. Behaves the same as 
;			XFRAC, see above. 
;
;	TEST = Boolean or Integer Array [Nx,Ny]. Set to launch a window that will display the  
;		   plot positions. If TEST=1, then a default-sized window will be created. If 
;		   test is a 2-element array, then the window will have dimensions [test[0],test[1]]. 
;
;	_EXTRA = Keyword inheritance for the test PLOT commands. Note that the flexibility of 
;			 the test capabilities are deliberately limited, as this routine is meant to 
;			 simply generate positions. 
;
;
; EXAMPLES:
;	pos = panel_positions([3,2], xfrac=[0.2,0.4,0.4], yfrac=[0.8,0.2], /test)
;
; NOTES:
;	This routine cannot generate completely arbitrary panel sizes. Each panel row must 
;	have the same Y-dimension and each panel column must have the same X-dimensions. 
;	Arbitrary panel sizes can be produced by utilizing multiple calls to PANEL_POSITIONS. 
;	This can be facilitated by passing a string array containing the list of arguments and 
;	keywords for each call. For example, you can do:
;
;	args = strarr(3)
;	args[0] = '[1,2], x1=0.1, xn=0.45, yfrac=[0.7,0.3]'
;	args[1] = '[1,2], x1=0.55, xn=0.90'
;	args[2] = '[1,1], x1=0.96, xn=0.99, y1=0.30, yn=0.78'
;	pos = panel_positions(args, /test)
;
; CALLS: 
;	None. 
;
; MODIFICATION HISTORY: 
;	 - 2016/09/16 - Written by Patrick McCauley (mccauley.pi@gmail.com)
;	 - 2018/10/23 - Added additional error handling 
;
;-
; ========================================================================================

;String input option for recursive calls, see note. 
if size(npanels, /tname) eq 'STRING' then begin

	for i=0, n_elements(npanels)-1 do begin
		command = 'position = panel_positions('+npanels[i]+')'
		result = execute(command)
		
		if n_elements(positions) eq 0 then positions = position $
			else positions = [[positions],[position]]
	endfor

	sz = size(positions, /dim)
	if n_elements(sz) eq 2 then panel_count = sz[1] else panel_count = 1

;Normal usage
endif else begin

	;---inputs and keywords

	if n_elements(npanels) eq 1 then npanels = [npanels,1]
	panel_count = npanels[0]*npanels[1]

	if not keyword_set(x1) then x1 = 0.1
	if not keyword_set(xn) then xn = 0.98

	if not keyword_set(y1) then y1 = 0.1
	if not keyword_set(yn) then yn = 0.98

	if npanels[0] gt 1 then begin 
		if n_elements(xgap) eq 1 then xgap = fltarr(npanels[0]-1)+xgap
		if n_elements(xgap) eq 0 then xgap = fltarr(npanels[0]-1)+0.1
	endif

	if npanels[1] gt 1 then begin
		if n_elements(ygap) eq 1 then ygap = fltarr(npanels[1]-1)+ygap
		if n_elements(ygap) eq 0 then ygap = fltarr(npanels[1]-1)+0.1
	endif

	if not keyword_set(xfrac) then xfrac = fltarr(npanels[0]) + 1./npanels[0]
	if not keyword_set(yfrac) then yfrac = fltarr(npanels[1]) + 1./npanels[1]

	;---check for keyword errors

	if n_elements(xgap) ne npanels[0]-1 then begin
		message, 'Oops, XGAP should have n_elements = NPANELS[0]-1 = '+trim(npanels[0]-1), /info
		return, -1
	endif

	if n_elements(ygap) ne npanels[1]-1 then begin
		message, 'Oops, YGAP should have n_elements = NPANELS[1]-1 = '+trim(npanels[1]-1), /info
		return, -1
	endif

	if n_elements(xfrac) ne npanels[0] then begin
		message, 'Oops, XFRAC should have n_elements = NPANELS[0] = '+trim(npanels[0]), /info
		return, -1
	endif

	if n_elements(yfrac) ne npanels[1] then begin
		message, 'Oops, YFRAC should have n_elements = NPANELS[1] = '+trim(npanels[1]), /info
		return, -1
	endif
	
	if abs(total(xfrac)-1) gt 0.0001 then begin
		message, 'Oops, total(XFRAC) =/= 1', /info
		return, -1
	endif
	
	if abs(total(yfrac)-1) gt 0.0001 then begin
		message, 'Oops, total(YFRAC) =/= 1', /info
		return, -1
	endif

	;----Generate Positions

	;determine available plot area and panel dimensions
	if npanels[0] gt 1 then xspace = (xn-x1) - total(xgap) $
		else xspace = (xn-x1)
	xdim = xspace*xfrac

	if npanels[1] gt 1 then yspace = (yn-y1) - total(ygap) $
		else yspace = (yn-y1)	
	ydim = yspace*yfrac

	;determine x and y panel positions
	x = fltarr(npanels[0]*2)+x1
	for i=1, n_elements(x)-1 do begin
		if (i mod 2) eq 1 then x[i] = x[i-1] + xdim[(i-1)/2] $
			else x[i] = x[i-1] + xgap[(i/2)-1]
	endfor

	y = fltarr(npanels[1]*2)+y1
	for i=1, n_elements(y)-1 do begin
		if (i mod 2) eq 1 then y[i] = y[i-1] + ydim[(i-1)/2] $
			else y[i] = y[i-1] + ygap[(i/2)-1]
	endfor

	;combine x and y positions 
	for i=0, n_elements(x)/2 -1 do begin
		for j=0, n_elements(y)/2 -1 do begin
			position = [x[i*2],y[j*2], x[i*2 +1], y[j*2 +1]]		
			if n_elements(positions) eq 0 then positions = position $
				else positions = [[positions],[position]]
		endfor
	endfor

endelse

;---Sort from left-to-right, top-to-bottom, like a book

if keyword_set(book) then begin 
	x1s = positions[0,*]
	y1s = positions[1,*]
	srt = multisort(y1s, x1s, order=[-1,+1])
	positions = positions[*,srt]
endif

;---Test window

if keyword_set(test) then begin
	if n_elements(test) gt 1 then window, xs=test[0], ys=test[1] $
		else window
	
	if keyword_set(no_ticks) then begin
		xtickname=strarr(20)+' '
		ytickname=strarr(20)+' '
	endif 
	
	for i=0, panel_count-1 do begin 
		plot, indgen(11), indgen(11), position=positions[*,i], noerase=(i gt 0), /nodata, $
			xtickname=xtickname, ytickname=ytickname, _extra=_extra
		
		xyouts, mean(!x.crange), mean(!y.crange), 'Position '+trim(i), align=0.5, /data
			
	endfor

endif


return, positions
end
