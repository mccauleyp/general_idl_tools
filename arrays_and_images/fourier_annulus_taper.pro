function fourier_annulus_taper, image, plot=plot, $
		boundary=boundary, style=style, taper_style=taper_style

; ========================================================================================
;+
; NAME: 
;	FOURIER_ANNULUS_TAPER
;
; CATEGORY: 
;	Array Operations
;
; PURPOSE: 
;	Apply a cosine or linear taper to the Fast Fourier Transform of an image, such that 
;   beyond some innermost region, the FFT result smoothly falls to 0.  
;
; INPUTS: 
;	IMAGE = 2D image array
;
; OUTPUTS: 
;	RETURN = 2D array containing FFT result with taper applied
;         
; KEYWORDS: 
;	PLOT = Boolean, set to plot result and show annulus
;
;   BOUNDARY = [1,N] Radial boundary beyond which to begin the taper in pixels. Default 
;               to [1,20]. I don't remember why the first element of this array was needed
;               (see notes)
;
;   STYLE = Boolean, default=1. Set to 0 to instead apply a graded taper at intervals 
;           of reset_percent = [1.,0.75,0.5,0.25] times the original FFT value
;
;   TAPER_STYLE = String, can be 'linear' or 'cosine', defaults to 'cosine'
;
; EXAMPLES:
;	
;
; NOTES:
;	Experimental routine. I didn't end up implementing this for any results. 
;
; CALLS: 
;   DEFAULT, AL_LEGEND, PLOT_IMAGE, TVELLIPSE
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

		
default, style, 1

ft = fft(image, /center)

sz = size(image, /dim)
cen=sz/2


yy = (indgen(sz[0])-cen[1]) ## (1. + fltarr(sz[1])) 
xx = (1. + fltarr(sz[0])) ## (indgen(sz[1])-cen[0])
rr = sqrt(yy^2 + xx^2)

if not keyword_set(style) then begin 

	ranges = [0, 1, 2, 4, 8]
	reset_percent = [1.,0.75,0.5,0.25]

	ranges = findgen(30)

	reset_potential = [1.,0.]
	reset_delta = (reset_potential[1] - reset_potential[0])/(n_elements(ranges)-2)

	reset_percent = reset_potential[0] + findgen(n_elements(ranges)-1)*reset_delta

	for i=0, n_elements(ranges)-2 do begin

		want = where(rr ge ranges[i] AND rr lt ranges[i+1], count)
		;---Fill pixels
		if count gt 0 then begin 
		
			ft[want] = ft[want] - ft[want]*reset_percent[i]
		
		endif

	endfor

endif else begin 
	if not keyword_set(boundary) then boundary = [1,20]
	
	want = where(rr lt boundary[1], count)
	ind = array_indices(rr, want)
	
	if count eq 0 then begin
		message, 'Oops, no pixels with radius less than '+trim(boundary), /info
		return, -1
	endif

	default, taper_style, 'cosine'
	
	case taper_style of
		
		'linear': begin
			taper_percent = (-1./boundary[1])*rr[want] + 1
		end
		
		'cosine': begin
			rr_scl = (rr[want]/max(rr[want]))*90.
			taper_percent = cos(rr_scl/!radeg)
		end
		
	endcase

	ft1 = ft
	
	ft[want] = ft[want] - ft[want]*taper_percent
	
	if keyword_set(plot) then begin 
	
		!p.multi=[0,2,2]
	
		window, 10, xs=1024, ys=1024
		plot_image, abs(ft1[216:296,216:296]), title='Unmodified |FFT|', xtitle='Inner pixels', ytitle='Inner pixels', charsize=1.5
		xyouts, 8, 8, 'Max Real Component = '+trim(max(real_part(ft1))), /data, charsize=1.5
	
		plot_image, abs(ft[216:296,216:296]), title='Modified |FFT|', xtitle='Inner pixels', ytitle='Inner pixels', charsize=1.5
		xyouts, 8, 8, 'Max Real Component = '+trim(max(real_part(ft))), /data, charsize=1.5
		tvellipse, boundary[1], boundary[1], 40, 40
		al_legend, 'Taper radius', line=0, /top, /left, box=0, charsize=1.5
	
	
		plot_image, abs(alog10(ft1[216:296,216:296])), title='Unmodified log(|FFT|)', xtitle='Inner pixels', ytitle='Inner pixels', charsize=1.5
	
		plot_image, abs(alog10(ft[216:296,216:296])), title='Modified log(|FFT|)', xtitle='Inner pixels', ytitle='Inner pixels'	, charsize=1.5
		tvellipse, boundary[1], boundary[1], 40, 40
	
		!p.multi=0
	
	endif
	
endelse

output = fft(ft, /center, /inverse)

if keyword_set(plot) then begin
	window, 0
	!p.multi = [0,2,1]
	
	plot_image, image, title='Input image'
	plot_image, output, title='Filtered image'

	!p.multi=0

endif


return, output
end
