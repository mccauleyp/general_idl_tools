function default_ps, fname, dim, x=x, z=z, test=test, basic=basic, _extra=_extra

; ========================================================================================
;+
; NAME: 
;	DEFAULT_PS
;
; CATEGORY: 
;	Plotting
;
; PURPOSE: 
;	Create a PostScript container and return a structure with some default settings that 
;   can passed to the various plotting codes using the _extra keyword
;
; INPUTS: 
;	FNAME = '/path/to/plot.eps'
;
;   DIM = [x,y] dimensions in pixels (will be converted to inches for PS device)
;
; OUTPUTS: 
;	RETURN = Structure containing the following plot keywords
;	            struct.font = 3
;	            struct.charsize = 1.25
;	            struct.char_reduce=0.5
;	            struct.xthick = 6
;	            struct.ythick = 6
;	            struct.thick = 4
;	            struct.postscript=1
;	            struct.hsize=200
;
;   The FNAME file will be created using the set_plot, 'ps' command with some default 
;   settings
;         
; KEYWORDS: 
;   X = Boolean, set to return default settings for the X device instead.
;
;   Z = Boolean, set to return default settings for the Z device instead
;
;   TEST = Boolean, set to generate an X-window first to test things out. If set, 
;          the PostScript file isn't created.
;
;   BASIC = Structure, optional output. This contains only the bare-bones plot keywords, 
;           which can be useful if passing to routines in the Coyote Library in particular
;
;   _EXTRA = Can also pass any additional keyword and it'll get added into the return
;            structure. 
;	
;
; EXAMPLES:
;	plot_settings = default_ps('~/plot.eps', [500,500])
;
; NOTES:
;	
;
; CALLS: 
;   REM_TAG, ADD_TAG
;
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if n_params() ne 2 then begin
	message, 'Oops, missing inputs', /info
	return, -1
end

struct = {fname:fname, postscript:1, dim:dim, $
			charsize:1., char_reduce:0, $
			xthick:1., ythick:1., thick:1, $
			font:0.,hsize:0}

if keyword_set(test) OR keyword_set(x) then begin
	set_plot, 'x'
	window, xs=dim[0], ys=dim[1]
	struct.charsize=1.5
	struct.char_reduce=0.5
	struct.xthick=2
	struct.ythick=2
	struct.postscript=0
	struct.font=-1
	struct.hsize=8
endif else if keyword_set(z) then begin
	set_plot, 'z'
	device, set_r=dim, decomposed=0, set_pixel_depth=24
	struct.charsize=1.25
	struct.char_reduce=0.5
	struct.xthick=2
	struct.ythick=2
	struct.postscript=0
	struct.font=-1
	struct.hsize=8
endif else begin
	set_plot, 'ps'
	device, /encapsulated, /inches, /portrait, /color, decomposed=0, bits_per_pixel=8, $
			xsize=dim[0]/100., ysize=dim[1]/100., filename=fname
	struct.font = 3
	struct.charsize = 1.25
	struct.char_reduce=0.5
	struct.xthick = 6
	struct.ythick = 6
	struct.thick = 4
	struct.postscript=1
	struct.hsize=200
endelse

basic = rem_tag(struct, ['FNAME','POSTSCRIPT','DIM','CHAR_REDUCE', 'HSIZE', 'THICK'])

if n_elements(_extra) gt 0 then begin
	
	tags = tag_names(struct)
	extags = tag_names(_extra)

	for i=0, n_elements(extags)-1 do begin
		want = where(tags eq extags[i], count)
		if count gt 0 then struct.(want[0]) = _extra.(i) $
			else struct = add_tag(struct, _extra.(i), extags[i])
	endfor

end



return, struct
end
