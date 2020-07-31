pro extract_frames, movie_file, dirout=dirout

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	EXTRACT_FRAMES
;
; CATEGORY: 
;	Image Processing
;
; PURPOSE: 
;	Extract frames from a movie file using FFMPEG.
;
; CALLING SEQUENCE:
;	extract_frames, movie_file [,dirout=dirout]
;
; INPUTS: 
;	MOVIE_FILE - [Mandatory] (String)
;				'/path/to/movie.mp4', can be any movie file format
;
; OUTPUTS: 
;	No IDL outputs but image frames will be written to DIROUT.
;         
; KEYWORDS: 
;	DIROUT - [Optional] (String)
;			'/path/to/output/dir/'. The default is a new directory with the same name 
;			as the movie file.
;	
; EXAMPLES:
;	IDL> file = '~/movie.mp4'
;	IDL> extract_frames, file
;
; NOTES:
;	This routine requires that FFMPEG be installed. 
;
; MODIFICATION HISTORY: 
;	2013/06/02 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if not keyword_set(dirout) then begin
	banana = strsplit(movie_file, '/', /extract)
	base = strsplit(file_basename(movie_file), '.', /extract)
	banana[n_elements(banana)-1] = base[0]
	dirout = '/'+strjoin(banana[0:n_elements(banana)-1], '/')+'/'
endif

if file_test(dirout, /dir) eq 1 then file_delete, dirout, /recursive $
else file_mkdir, dirout

command = 'ffmpeg -i '+movie_file+' '+dirout+'image-%3d.jpeg'

spawn, command, result, errResult

return
end
