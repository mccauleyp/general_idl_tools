function mcwrite_cube, index, data, outfile, header=header, append=append

; ========================================================================================
;+
; NAME: 
;   McWRITE_CUBE
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Write a tile-compressed FITS image cube that can be read with McREAD_CUBE
;
; INPUTS: 
;   INDEX = (Structure Array) Header structures for each image in the cube
;
;   DATA = (Float Array) [Nx,Ny,Nimgs] data array
;
;   OUTFILE = (String) '/path/to/output.fits'
;
; OUTPUTS: 
;   RETURN = (Float Array) Tile-compressed version of DATA
;
;   OUTFILE will also be written with the RETURN cube. 
;         
; KEYWORDS: 
;   HEADER = (String Array) INDEX structure headers in string form
;
;   APPEND = (Structure) Additional {tag:value} pairs to be appended to HEADER before the 
;            file is written
;
; NOTES:
;   Files can be read with McREAD_CUBE
;
;   Modeled after the SDO tile compression methods combined with TRACE data cube format.
;
;   Used to write compressed MWA data cubes.    
;
; CALLS: 
;   COMPARE_STRUCT, STRUCT2FITSHEAD, REM_TAG, STR_REPLACE, SXADDPAR, SXADDHIST, WRITEFITS,
;   SSW_IMCOPY, MWRFITS
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

progname = 'MCWRITE_CUBE.PRO'
progver = 'V0.0' ; 2017/04/20 (PIM)

inputs = [n_elements(index) gt 0, $
		  n_elements(data) gt 0, $
		  n_elements(outfile) gt 0]
		  
if total(inputs) ne n_elements(inputs) then begin 
	message, 'Oops, missing input(s).', /info
	return, -1
endif

sz = size(data, /dim)

if n_elements(sz) ne 3 then begin
	message, 'Oops, DATA should be a 3D image array.', /info
	return, -1
endif

if sz[2] ne n_elements(index) then begin
	message, 'Oops, number of INDEX elements does not equal number of DATA images.', /info
	return, -1
endif

if n_elements(header) eq 0 then begin 
	compare = compare_struct(index[0], index[1])
	header = struct2fitshead(rem_tag(index[0], str_replace(compare.field, '.')))
	sxaddpar, header, 'naxis', 3
	sxaddpar, header, 'naxis3', n_elements(index), after='NAXIS2'
	sxaddhist, progname+' '+progver+' run at: '+systim(), header
endif else begin 
	if size(header, /tname) ne 'STRING' then begin 
		message, 'Oops, HEADER should be a string array.', /info
		return, -1
	endif
endelse

if keyword_set(append) then begin 
	tags = tag_names(append)
	for i=0, n_elements(tags)-1 do sxaddpar, header, tags[i], append.(i)
endif

writefits, outfile, data, header

cube = ssw_imcopy(outfile, /compress, /in_situ)

mwrfits, index, cube

return, cube
end
