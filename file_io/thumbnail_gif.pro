pro thumbnail_gif, imgdir, dirout=dirout, frames=frames, dim=dim, bin=bin, $
					delay=delay, extension=extension, fname=fname

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	THUMBNAIL_GIF
;
; CATEGORY: 
;	Image Processing
;
; PURPOSE: 
;	Make a thumbnail GIF animation from an image directory
;
; CALLING SEQUENCE:
;	thumbnail_gif, imgdir [,dirout=dirout] [,frames=frames] [,dim=dim] [,bin=bin] 
;					[,delay=delay] [,extension=extension] [,fname=fname]
;
; INPUTS: 
;	IMGDIR - (String)
;			'/path/to/directory/with/images/' The images may be in any of the following 
;			file formates: JP2, PNG, JPG, JPEG, GIF, TIFF
;
; OUTPUTS: 
;	No IDL output an animated gif will be written. 
;         
; KEYWORDS: 
;	DIROUT - (String)
;			'/path/to/output/dir/', defaults to one level above IMGDIR
;	FRAMES - (Integer)
;			Number of frames for animated GIF. Default is 10. 
;	DIM - (Integer)
;			X-dimension for GIF in pixels. Default is 200. 
;	BIN - (Integer)
;			Alternative to the DIM keyword. If the image is 1024x1024 and BIN is set to 4, 
;			the the GIF will be written at 256x256 pixels.
;	DELAY - (Integer)
;			Delay between frames in milliseconds. Default is 50. 
;	EXTENSION - (String)
;			File extension for images (.png, .tiff, etc). Only necessary if there are 
;			multiple file types stored in IMGDIR.
;	FNAME - (String)
;			Filename. Default is the same as the IMGDIR directory name.
;
; EXAMPLES:
;	IDL> thumbnail_gif, imgdir
;
; NOTES:
;	If you want to make a thumbnail GIF animation from a movie but don't have the frames, 
;	you can use the EXTRACT_FRAMES routine first to populate IMGDIR. 
;
; MODIFICATION HISTORY: 
;	2013/05/03 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if strmid(imgdir, strlen(imgdir)-1, 1) ne '/' then imgdir = imgdir + '/'

;Set default directory to one above IMGDIR
if not keyword_set(dirout) then begin
	banana = strsplit(imgdir, '/', /extract)
	dirout = '/'+strjoin(banana[0:n_elements(banana)-2], '/')+'/'
endif

if not keyword_set(fname) then begin
	banana = strsplit(imgdir, '/', /extract)
	fname = banana[n_elements(banana)-1]+'.gif'
endif

if not keyword_set(frames) then frames = 10
if not keyword_set(delay) then delay = 50
if n_elements(dim) eq 0 then dim = 200

if n_elements(bin) gt 0 AND n_elements(dim) gt 0 then begin
	message, 'Cannot set both BIN and DIM keywords.', /informational
	return
endif

if not keyword_set(extension) then begin
	list = file_search(imgdir, '*.*')
	base = file_basename(list[0])
	banana = strsplit(base, '.', /extract)
	extension = banana[n_elements(banana)-1]
endif

list = file_search(imgdir, '*.'+extension)

if strpos(fname, '.gif') eq -1 then fname = fname+'.gif'

;Allow for most image types to be used
case extension of
	'jp2': command = 'jp2_read, list[ind[i]], index, data'
	'png': command = 'data = read_png(list[ind[i]])'
	'jpg': command = 'read_jpeg, list[ind[i]], data'
	'jpeg': command = 'read_jpeg, list[ind[i]], data'
	'gif': command = 'data = read_gif(list[ind[i]])'
	'tiff': command = 'data = read_tiff(list[ind[i]])'
endcase	

;Read first file 
i=0 & ind = indgen(n_elements(list))
result = execute(command)

;Get size
sz = size(data, /dimensions)
if n_elements(sz) eq 3 then sz = sz[1:*]

if n_elements(bin) gt 0 then begin 
	dim = fix(float(sz)/bin)
	dim = dim + dim mod 2 ;ensure that DIM is event
endif

;Determine dimensions if only one is supplied. 
if n_elements(dim) eq 1 then begin
	if sz[0] eq sz[1] then dim = [dim, dim] else begin
		bin = sz[0] / dim
		dim = [dim, fix(sz[1]/dim)]
	endelse
endif 

set_plot, 'z'
device, set_r=dim, decomposed=0, set_pixel_depth=24

ind = indgen(frames)*(n_elements(list)-1)/9

if file_test(dirout+fname) eq 1 then file_delete, dirout+fname

for i=0, n_elements(ind)-1 do begin

	result = execute(command)
	sz = size(data, /dimensions)
	
	if n_elements(sz) eq 3 then begin
		data = congrid(data, 3, dim[0], dim[1])
		data = color_quan(data, 1, r, g, b)
	endif else begin 
		data = congrid(data, dim[0], dim[1])
		loadct, 0, /silent
		tvlct, r, g, b, /get
	endelse

	if i eq 0 then write_gif, dirout+fname, data, r, g, b
	write_gif, dirout+fname, data, r, g, b, /multiple, repeat_count=0, delay=delay
	if i eq n_elements(ind)-1 then write_gif, dirout+fname, data, r, g, b, /close

endfor

message, 'Created '+dirout+fname, /informational

return
end
