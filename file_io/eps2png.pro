pro eps2png, eps, png, result=result, errResult=errResult, delete=delete, quiet=quiet, size=size, density=density

; ========================================================================================
;+
; NAME: 
;	EPS2PNG
;
; CATEGORY: 
;	File IO
;
; PURPOSE: 
;	Convert an EPS file to a PNG file using the CONVERT command from ImageMagick
;
; INPUTS: 
;	EPS = '/path/to/file.eps'
;
;   PNG = Optional, '/path/to.png', defaults to EPS name with extension swapped
;
; OUTPUTS: 
;	PNG file created
;         
; KEYWORDS: 
;	RESULT = Output string containing console messages from ImageMagick
;
;   ERRRESULT = Output string with console error message, if applicable
;
;   DELETE = Boolean, set to delete EPS file after conversion
;
;   QUIET = Boolean, set to suppress messages
;
;   SIZE = Optional [X,Y] pixel dimensions (generally not needed unless EPS is very large)
;
;   DENSITY = Pixel density, defaults to 100. Decrease for coarser image. 
;
; EXAMPLES:
;	
;
; NOTES:
;	This routine uses SPAWN to run the Unix convert command, which requires ImageMagick
;   be installed. You'll get an error message if the command isn't found. 
;
; CALLS: 
;   DEFAUlT, STR_REPLACE, TRIM, SPAWN -> CONVERT
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, density, 100

if n_elements(png) eq 0 then png = str_replace(eps, '.eps', '.png')

if keyword_set(size) then sz = '-extent '+trim(size) else sz = ''

spawn, 'which convert', result, errResult

if result ne '' then convert_path = result else begin
	message, 'Oops, CONVERT (ImageMagick) does not seem to be installed: ', /info
	spawn, 'which convert'
	return
endelse

if keyword_set(quiet) then $
	spawn, convert_path+' -colorspace sRGB '+sz+' -flatten -density '+trim(density)+' '+eps+' '+png, result, errResult $
else $
	spawn, convert_path+' -colorspace sRGB '+sz+' -flatten -density '+trim(density)+' '+eps+' '+png
	
if keyword_set(delete) then file_delete, eps

return
end
