function pixel_select, input_image, reset_value=reset_value, thresh=thresh, $
						resolution=resolution, no_plots=no_plots, no_prompt=no_prompt, $
						replot=replot, continuous=continuous, silent=silent, $
						active=active, yaxis=yaxis, xaxis=xaxis, taxis=taxis, $
						no_round=no_round, _extra=_extra

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	PIXEL_SELECT
;
; CATEGORY: 
;	Image Processing
;
; PURPOSE: 
;	Interactively select a set of pixels on an image using CURSOR. 
;
; CALLING SEQUENCE:
;	pixel_select, input_image, [,reset_value=reset_value] [,thresh=thresh] 
;					[,resolution=resolution] [,plots=plots]
;
; INPUTS: 
;	INPUT_IMAGE - (2-D Array)
;				Image array to select pixels from. It will be automatically byte scaled.
;
; OUTPUTS: 
;	RETURN - (Integer Array)
;			[x,y,Npixels] coordinates of the selected pixels
;         
; KEYWORDS: 
;	RESET_VALUE - (Number)
;				Value to reset selected pixels to for display. By default it will be the 
;				maximum value of INPUT_IMAGE.
;	THRESH - (Number)
;				Value to threshold the input image for display (i.e. plot_image, input_image > thresh)
;	RESOLUTION - (2-element Array)
;				[x,y] dimensions of graphics windows, default [1280,720]
;	PLOTS - (Boolean)
;				By default, the selected pixels will be reset to the RESET_VALUE, so you 
;				know which pixels have been selected by their change in color. For large 
;				images, this can be hard to see. Set this keyword so that a cross is plotted 
;				atop the selected pixels as well, making them easier to see. 
;	NO_PROMPT - (Boolean)
;				Set to disable the command-line prompt that ask if you're really done upon 
;				right clicking at the end.
;
; EXAMPLES:
;	IDL> img = bytarr(256,256)
;	IDL> pixels = pixel_select(img)
;
; NOTES:
;	None.
;
; MODIFICATION HISTORY: 
;	2012/05/03 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)	
;	2016/03/31 - Added REPLOT, NO_PLOTS, and CONTINUOUS keywords. 
;	2016/04/06 - Added ACTIVE, XAXIS, YAXIS, and NO_ROUND keywords.
;	2017/11/30 - Updated to handle true color or grayscale images automagically 
;	2018/11/25 - Added _extra keyword
;
;-
; ========================================================================================


if keyword_set(active) AND keyword_set(replot) then begin
	message, 'Oops, ACTIVE and REPLOT keywords are not compatible', /info
	return, -1
endif

if n_elements(input_image) eq 0 then begin
	message, 'No INPUT_IMAGE supplied, using active window (/ACTIVE)', /info
	active = 1
endif

if total([keyword_set(xaxis), keyword_set(yaxis)]) eq 1 then begin
	message, 'Oops, must set both XAXIS and YAXIS (or neither).', /info
	return, -1
endif

if not keyword_set(active) then begin 
	set_plot, 'x'

	if not keyword_set(resolution) then resolution = [1280,720]

	window, 20, xsize=resolution[0], ysize=resolution[1]

	if n_elements(pixels) ne 0 then temp = temporary(pixels)

	if not keyword_set(reset_value) then reset_value = max(input_image) + 1
	if not keyword_set(thresh) then thresh=min(input_image)

	temp = input_image
	dim = size(input_image, /dim)
	
	if n_elements(dim) eq 3 then begin
		true = 1
		xdim = [0D,dim[1]]
		ydim = [0D,dim[2]]
	endif else begin
		true = 0
		xdim = [0D,dim[0]]
		ydim = [0D,dim[1]]
	endelse
endif else begin 
	if !d.name ne 'X' then begin
		message, 'Oops, must use the X-window display (SET_PLOT, ''X'')', /info
		return, -1
	endif
	if !window eq -1 then begin
		message, 'Oops, there is no active window (!WINDOW = -1)', /info
		return, -1
	endif
	xdim = !x.crange
	ydim = !y.crange
	redo_img = tvrd(true=1)
endelse

!mouse.button = 0

if keyword_set(taxis) then form="($,'x = ',A0,', y = ',i5,a)" $
else form="($,'x = ',i5,', y = ',i5,a)"

yn = ''

repeat begin

	if yn eq 'n' then begin
	
		if n_elements(pixels) gt 0 then temp = temporary(pixels)
	
		if keyword_set(active) then begin 
				if not keyword_set(no_plots) then plots, pixels, /data, color=0, thick=2, psym=6, symsize=2
				if not keyword_set(no_plots) then plots, pixels, /data, color=255, thick=1, psym=6, symsize=2	
		endif else temp = input_image
		
		!mouse.button = 0
	endif
	
	if not keyword_set(active) then $
		plot_image, temp > thresh, title='Left Click to Select, Right Click to Finish', charsize=2, ytitle='Pixels', xtitle='Pixels', true=true, _extra=_extra

	while (!mouse.button ne 4) do begin  
		cursor, x,y, 2, /data
		if !mouse.button eq 1 then begin 
			pixel = [x,y]
			if pixel[0] ge xdim[0] AND pixel[0] le xdim[1] AND pixel[1] ge ydim[0] AND pixel[1] le ydim[1] then begin
				boost_array, pixels, pixel
				if keyword_set(replot) then begin
					temp[pixel[0],pixel[1]] = reset_value
					plot_image, temp > thresh, title='Left Click to Select, Right Click to Finish', charsize=2, ytitle='Pixels', xtitle='Pixels', ture=true
				endif
				if not keyword_set(no_plots) then plots, pixel, /data, color=0, thick=2, psym=1, symsize=2
				if not keyword_set(no_plots) then plots, pixel, /data, color=255, thick=1, psym=1, symsize=2
			endif
			if not keyword_set(silent) then print,''
			if not keyword_set(continuous) then wait, 0.2
		endif 
		if not keyword_set(silent) then begin
			if keyword_set(taxis) then xp = anytim(x, /ccsds) else xp = x
			yp = y
			print, form=form, xp, yp, string("15b)
		endif
	endwhile  
	if not keyword_set(silent) then print, form='($,a,a)', strjoin(strarr(45)+' '), string("15b)
	

	if not keyword_set(no_prompt) then begin
		message, 'Satisfied? Enter n to start over.', /info
		repeat read, yn, prompt='y/n: ' until yn eq 'y' or yn eq 'n' ;or yn eq 'reset'
	endif else yn = 'y'

endrep until yn eq 'y' 

if n_elements(pixels) eq 0 then begin 
	message, 'No pixels selected', /info
	return, -1
endif

if not keyword_set(active) then wdelete, 20

if keyword_set(xaxis) then begin 

	new_px = pixels*0
	
	for i=0, n_elements(new_px)/2 -1 do begin
		temp = min(abs(pixels[0,i] - xaxis), x_ind)
		temp = min(abs(pixels[1,i] - yaxis), y_ind)
		new_px[*,i] = [x_ind, y_ind]
	endfor
	
	pixels = new_px
endif

if not keyword_set(no_round) then pixels = round(pixels)

return, pixels
    
end
