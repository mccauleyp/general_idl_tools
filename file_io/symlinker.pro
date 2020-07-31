function symlinker, dir, extension=extension, symlinks=symlinks, dirout=dirout, list=list, quiet=quiet

; ========================================================================================
;+
; NAME: 
;   SYMLINKER
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Create a set of sequentially-named symlinks for files in a directory 
;   (e.g. 0001.ext, 0002.ext, ...)
;
; INPUTS: 
;   DIR = (String) '/path/to/your/files/'
;
; OUTPUTS: 
;   RETURN = '/path/to/symlinks/'
;
;   The files in DIR will all get corresponding symlinks in this directory
;         
; KEYWORDS: 
;   EXTENSION = (String) This is only needed if there are files in DIR with multiple 
;               extensions. Set to specify which files you want to symlink.
;
;   SYMLINKS = (String Array) Paths to the symlinks themselves.
;
;   DIROUT = (String) Directory to put the symlinks in. Defaults to a subdirectory 
;            inside DIR called "symlinks/"
;
;   LIST = (String Array) List of files found in DIR
;
;   QUIET = (Boolean) Set to suppress messages. 
;
; NOTES:
;   The files must be named such that the FILE_SEARCH() function returns them in the 
;   order you want them. This routine is useful for applications where whatever sequential 
;   naming convention you've used isn't compatible with something else that needs a
;   simpler set of names. For instance, passing a set of images into FFMPEG to produce 
;   a movie from them. 
;
; CALLS: 
;   TRIM
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

if keyword_set(dirout) then symdir=dirout else symdir = dir+'/symlinks/'

if file_test(symdir, /directory) eq 1 then file_delete, symdir, /recursive

if not keyword_set(extension) then begin 
	list = file_search(dir+'*')
	
	if n_elements(list) eq 1 AND list[0] eq '' then begin 
		message, 'No image files found.', /info 
		return, 'ERROR'
	endif
	
	banana = strsplit(list[0], '.', /extract)
	extension = banana[n_elements(banana)-1]
	
	temp = where(strpos(list, extension) eq -1, count)
	if count gt 0 then begin
		message, 'Files in input directory have different extensions. Specify an extension with the extension keyword.', /info
		return, 'ERROR'
	end	
endif else list = file_search(dir, '*.'+extension)

;make sure images are found 
if n_elements(list) lt 2 then begin
	message, 'Less than two images found', /info
	return, ['ERROR']
endif

file_mkdir, symdir

;copy symbolic links (this allows us to give ffmpeg the sequential filenames it is 
;expecting without modifying the original files or having to copy them outright.) 
symlinks = symdir+trim(lindgen(n_elements(list)))+'.'+extension
file_link, list, symlinks

if not keyword_set(quiet) then message, 'Created '+trim(n_elements(symlinks))+' symlinks in: '+symdir, /informational

return, symdir
end