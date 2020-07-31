pro pplot_image,img, _extra=_extra, no_frame=no_frame, frame_offset=frame_offset, tick_color=tick_color

; ========================================================================================
;+
; NAME: 
;   PPLOT_IMAGE
;
; CATEGORY: 
;   Plotting
;
; PURPOSE: 
;   Wrapper for PLOT_IMAGE to enable black axes and white tick marks. Replaced by 
;   MCPLOT_IMAGE but still in library because its called by a few other routines. 
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, frame_offset, [0,0]
default, tick_color, !p.background

if tick_color eq 0 then default, no_frame, 1 else default, no_frame, 0

;Written by Patrick McCauley

noticks = strarr(60)+' '

plot_image, img, _extra=_extra

if !d.name eq 'X' then return

_extra_alt = _extra
exclude = ['XTICKNAMES', 'YTICKNAMES', 'XTICKNAME', 'YTICKNAME', 'XTITLE', 'YTITLE', 'TITLE', 'COLOR', 'NOERASE']
for i=0, n_elements(exclude)-1 do _extra_alt = rem_tag(_extra_alt, exclude[i])

plot_image, img, _extra=_extra_alt, $
			xtickname=noticks, ytickname=noticks, color=tick_color, /noerase
			
;plot_image, img, _extra=_extra_alt, $
;			xtickname=noticks, ytickname=noticks, /noerase, xticklen=0.001, yticklen=0.001	

if not keyword_set(no_frame) then begin 
	tags = tag_names(_extra)
	if tag_exist(_extra, 'xthick') eq 1 then xthick = _extra.xthick else xthick = 1
	if tag_exist(_extra, 'ythick') eq 1 then ythick = _extra.ythick else ythick = 1

	;frame_offset = [0.0003,0.0003]*[xthick,ythick]
	fo = frame_offset

	;[x1,x2,y1,y1]
	frame = [!x.window[0]-fo[0], !x.window[1]+fo[0], $
			 !y.window[0]-fo[1], !y.window[1]+fo[1]]

	plots, [frame[0],frame[0]], [frame[2],frame[3]], color=!p.color, /norm, thick=ythick
	plots, [frame[1],frame[1]], [frame[2],frame[3]], color=!p.color, /norm, thick=ythick
	plots, [frame[0],frame[1]], [frame[2],frame[2]], color=!p.color, /norm, thick=xthick
	plots, [frame[0],frame[1]], [frame[3],frame[3]], color=!p.color, /norm, thick=xthick
endif

end
