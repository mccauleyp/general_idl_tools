pro mcplot_image, image, tick_color=tick_color, axis_color=axis_color, $
	no_data=no_data, no_labels=no_labels, no_ticks=no_ticks, _extra=_extra

; ========================================================================================
;+
; NAME: 
;   McPLOT_IMAGE
;
; CATEGORY: 
;   Plotting
;
; PURPOSE: 
;   Wrapper for the SolarSoft PLOT_IMAGE code that allows tick mark colors that are 
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
;   _EXTRA = Accepts all the same keywords as PLOT_IMAGE and PLOT
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
; CALLS: 
;   DEFAULT, REM_TAG, TAG_EXIST, PLOT_IMAGE
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, tick_color, 255
default, axis_color, 0

if !d.name eq 'X' then axis_color = 255

if n_elements(_extra) gt 0 then begin
	rem_tags = ['TITLE','XTITLE','YTITLE','XTICKNAME','YTICKNAME','NOERASE']
	_ex = rem_tag(_extra, rem_tags)
	_ext = rem_tag(_extra, 'NOERASE')
	if tag_exist(_extra, 'NOERASE') then noerase=_extra.noerase
endif	

!quiet=1
;plot image
if not keyword_set(no_data) then $
	plot_image, image, noerase=noerase, color=axis_color, ticklen=0.001, _extra=_ex, $
		title=' ', xtitle=' ', ytitle=' ', $
		ytickname=strarr(20)+' ', xtickname=strarr(20)+' '

tvlct, rr, gg, bb, /get
loadct, 0, /silent

;plot ticks
if not keyword_set(no_ticks) then $
	plot_image, image, /no_data, /noerase, color=tick_color, _extra=_ex, $
		title=' ', xtitle=' ', ytitle=' ', $
		ytickname=strarr(20)+' ', xtickname=strarr(20)+' '

;plot axes, titles
if not keyword_set(no_labels) then $
	plot_image, image, /no_data, /noerase, color=axis_color, ticklen=0.001, _extra=_ext
		
!quiet=0

return
end
