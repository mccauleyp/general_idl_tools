function rainbow_line_colors, nlines, ct=ct, channels=channels

; ========================================================================================
;+
; NAME: 
;   RAINBOW_LINE_COLORS
;
; CATEGORY: 
;   Plotting
;
; PURPOSE: 
;   Return integer values arbitrarily spaced across a rainbow color table to be used 
;   for line plots when you need many different colors.
;
; INPUTS: 
;   NLINES = (Int) Number of colors needed
;
; OUTPUTS: 
;   RETURN = (Int Array) Indexes of the color table to be used for each line
;         
; KEYWORDS: 
;   CT = (Int) Default = 34. IDL color table to use. (Could be a non-rainbow one.)
;
;   CHANNELS = (String Array) Used to return colors typically used (by me) for specific 
;              MWA frequency channels. 
;
; EXAMPLES:
;   plot, indgen(10), indgen(10)
;   colors = rainbow_line_colors(8)
;   for i=0, n_elements(colors)-1 do oplot, indgen(10), intarr(10)+(i+1), color=colors[i]
;   loadct, 0
;
; NOTES:
;   Will load a new color table, so you'll want to reset that after you're done plotting 
;   the color things.
;
; CALLS: 
;   DEFAULT, MATCH
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

;default, ct, 33
default, ct, 34
default, nlines, 12

loadct, ct, /silent

dcolor = 254./nlines
colors = reverse(round(findgen(nlines)*(254./(nlines-1))))

if keyword_set(channels) then begin
	chans = ['062-063','069-070','076-077','084-085','093-094','103-104','113-114','125-126','139-140','153-154','169-170','187-188']
	match, chans, channels, suba, subb
	if suba[0] eq -1 then $
		message, 'CHANNELS do not match reference channels.', /info $
	else $
		colors = colors[suba]
endif

return, colors
end
