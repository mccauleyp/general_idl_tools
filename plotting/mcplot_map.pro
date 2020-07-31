pro mcplot_map, map, tick_color=tick_color, axis_color=axis_color, $
	no_data=no_data, no_labels=no_labels, no_ticks=no_ticks, _extra=_extra, $
	background=background

; ========================================================================================
;+
; NAME: 
;   McPLOT_MAP
;
; CATEGORY: 
;   Plotting
;
; PURPOSE: 
;   Wrapper for the SolarSoft PLOT_MAP code that allows tick mark colors that are 
;   different from the axes color. For instance, if your plot border is black in an 
;   EPS figure, but you want white tick marks for better contrast.
;
; INPUTS: 
;   IMAGE = 2D image array
;
; OUTPUTS: 
;   None, image is plotted
;         
; KEYWORDS: 
;   _EXTRA = Accepts all the same keywords as PLOT_MAP
;
;   TICK_COLOR = Integer, color index in current color table (default = 255)
;
;   AXIS_COLOR = Integer, color for axes, default = 0 for PS device and 255 for X window
;
;   NO_DATA = Boolean, set to just draw the axes and tick marks without plotting the image
;
;   NO_LABELS = Boolean, set to exclude axes labels and tick values
;
;   NO_TICKS = Boolean, set to exclude tick marks
;
;   BACKGROUND = Boolean, set to initialize plot region with a black background before 
;                plotting. 
;
; CALLS: 
;   DEFAULT, REM_TAG, TAG_EXIST, PLOT_MAP
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

default, tick_color, 255
default, axis_color, 0

if !d.name eq 'X' then axis_color = 255

if n_elements(_extra) gt 0 then begin
	rem_tags = ['TITLE','XTITLE','YTITLE','XTICKNAME','YTICKNAME','NOERASE']
	_extra_image = rem_tag(_extra, [rem_tags,'XTICKLEN','YTICKLEN','TICKLEN'])
	_extra_ticks = rem_tag(_extra, rem_tags)
	_extra_labels = rem_tag(_extra, ['NOERASE','XTICKLEN','YTICKLEN','TICKLEN'])
	if tag_exist(_extra, 'NOERASE') then noerase=_extra.noerase
endif	

if keyword_set(background) then begin
	dummy_map = {data:bytarr(512,512), xc:0, yc:0, dx:20, dy:20, xunits:'arcsec', yunits:'arcsec', time:map.time, id:' '} 
	dummy_map.data[0,0]=1
	
	plot_map, dummy_map, noerase=noerase, color=axis_color, ticklen=0.00001, _extra=_ex, $
		title=' ', xtitle=' ', ytitle=' ', $
		ytickname=strarr(20)+' ', xtickname=strarr(20)+' '
	composite=2
endif else composite=0

!quiet=1
;plot image
if not keyword_set(no_data) then $
	plot_map, map, noerase=noerase, color=axis_color, ticklen=0.00001, _extra=_extra_image, $
		title=' ', xtitle=' ', ytitle=' ', $
		ytickname=strarr(20)+' ', xtickname=strarr(20)+' ', composite=composite

tvlct, rr, gg, bb, /get
loadct, 0, /silent

;plot ticks
if not keyword_set(no_ticks) then $
	plot_map, map, /no_data, /noerase, color=tick_color, _extra=_extra_ticks, $
		title=' ', xtitle=' ', ytitle=' ', $
		ytickname=strarr(20)+' ', xtickname=strarr(20)+' '

;plot axes, titles
if not keyword_set(no_labels) then $
	plot_map, map, /no_data, /noerase, color=axis_color, ticklen=0.00001, _extra=_extra_labels
		
tvlct, rr, gg, bb
!quiet=0

return
end
