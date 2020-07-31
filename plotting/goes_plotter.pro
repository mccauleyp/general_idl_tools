function goes_plotter, t1, t2, dir, fname=fname, data_sav=data_sav

; ========================================================================================
;+
; PROJECT: 
;	GOES
;
; NAME: 
;	GOES_PLOTTER
;
; CATEGORY: 
;	Resources
;
; PURPOSE: 
;	Write a basic GOES plot to a PNG file given a time range.
;
; CALLING SEQUENCE:
;	result = goes_plotter(t1, t2, dir [,fname=fname] )
;
; INPUTS: 
;	T1 - [Mandatory] (String or Double)
;		Time to start search in any format accepted by ANYTIM. 
;	T2 - [Mandatory] (String or Double)
;		Time to end search in any format accepted by ANYTIM. 
;	DIR - [Mandatory] (String)
;		'/path/to/output/dir/'
;
; OUTPUTS: 
;	RETURN - [Mandatory] (String)
;			'/path/to/goes_plot/png', path to PNG file 
;         
; KEYWORDS: 
;	FNAME - [Optional] (String)
;			'filename.png', default is 'goes_plot.png'
;
;	DATA_SAV - [Optional] (String)
;			'/path/to/filename.sav' to store output data. 
;
; EXAMPLES:
;	IDL> plot = goes_plotter('2012/01/01 00:00', '2012/01/02 00:00', '~/')
;	IDL> print, plot
;	~/goes_plot.png
;
; NOTES:
;	None.
;
; MODIFICATION HISTORY: 
;	Distant Past - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if not keyword_set(fname) then fname = 'goes_plot'

ct =  {black    : 0, $
      white     : 1, $
      red       : 2, $
      green     : 3, $
      blue      : 4, $
      yellow    : 5, $
      magenta   : 6, $
      cyan      : 7, $
      orange    : 8}

; Next we create red/green/blue vectors with value cominations that 
; give us the colors we want
;        0  1    2   3   4   5   6   7   8 
rr = [  0,255, 255,  0,  0,255,255,  0,255]
gg = [  0,255,   0,255,  0,255,  0,255,125]
bb = [  0,255,   0,  0,255,  0,255,255,  0]

; Lastly, we load the new color table
tvlct, rr, gg, bb

a = ogoes()

a->set, tstart=anytim(t1, /stime), tend=anytim(t2, /stime), /sdac, sat='goes15', mode=0, showclass=1
d = a->getdata(/force, /verbose, /remote)
times = a->getdata(/times)

times = anytim(anytim(t1)+times, /ccsds)

if d[0] eq -1 then begin
	message, 'Data not found for '+t1+' to '+t2, /info
	return, -1
endif

cs = 1.5

set_plot, 'z'
device, set_r=[768,512], decomposed=0, set_pixel_depth=24

utplot, times, d[*,0], charsize=cs, charthick=1, $
/ylog, yrange=[10D^(-9),10D^(-2)], ystyle=1, ytitle = 'Watts m!U-2', $ 
xrange=[times[0],times[n_elements(times)-1]], xstyle=1, /normal, title='GOES X-Ray Flux', $
yminor = 9, color=ct.white, /nodata

outplot, times, d[*,0], color=ct.red

outplot, times, d[*,1], color=ct.orange
      
axis, yaxis=1, ytickname=[' ','A','B','C','M','X',' ',' '], charsize=cs, ytitle=' ', yminor=9, $
/ylog, yrange=[10D^(-9),10D^(-2)], ystyle=1

x = anytim(times[n_elements(times)/30]) - anytim(times[0])
xyouts, x, 10D^(-2.50), '1.0 - 8.0 '+STRING(197B), charsize=cs, color=ct.red
xyouts, x, 10D^(-2.85), '0.5 - 4.0 '+STRING(197B), charsize=cs, color=ct.orange

write_png, dir+fname+'.png', tvrd(true=1)

if keyword_set(data_sav) then begin
	data = d
	units = 'Watts m!U-2'
	save, times, data, units, filename=data_sav
endif

return, dir+fname+'.png'
end
