pro mcread_cube, file, index, data, header=header, nodata=nodata, uncomp=uncomp, no_delete=no_delete, $
	quiet=quiet

; ========================================================================================
;+
; NAME: 
;   McREAD_CUBE
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Read a tile-compressed FITS image cube written with McWRITE_CUBE
;
; INPUTS: 
;   FILE = (String) '/path/to/data.fits'
;
; OUTPUTS: 
;   INDEX = (Structure Array) Header structures for each image in the cube
;
;   DATA = (Float Array) [Nx,Ny,Nimgs] data array
;         
; KEYWORDS: 
;   HEADER = (String Array) Headers in string form
;
;   NODATA = (Boolean) Set to only return INDEX (a bit faster)
;
;   UNCOMP = (String) Uncompressed file before being read
;
;   NO_DELETE = (Boolean) Set to *not* delete UNCOMP after read
;
;   QUIET = (Boolean) Set to suppress messages
;
; NOTES:
;   Files can be written with McWRITE_CUBE
;
;   Modeled after the SDO tile compression methods combined with TRACE data cube format.
;
;   Used to read compressed MWA data cubes.    
;
; CALLS: 
;   MRDFITS, MREADFITS_TILECOMP, FITSHEAD2STRUCT
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, quiet, 0

index = mrdfits(file, 2, silent=quiet)
if keyword_set(nodata) then return

mreadfits_tilecomp, file, 0, /only_uncompress, fnames_uncomp=uncomp, silent=quiet
data = mrdfits(uncomp, 0, header, silent=quiet)
header = fitshead2struct(header, silent=quiet)

if not keyword_set(no_delete) then file_delete, uncomp

return
end
