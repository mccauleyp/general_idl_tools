pro ffmpeg_combine, dir, framerate=framerate, fname=fname

; ========================================================================================
;+
; NAME: 
;   FFMPEG_COMBINE
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Given a directory containing .mp4 files, combine them into a single .mp4
;
; INPUTS: 
;   DIR = (String) '/path/to/mp4s/'
;
; OUTPUTS: 
;   New mp4 created in DIR with filename FNAME
;         
; KEYWORDS: 
;   FNAME = (String) 'filename.mp4', default = 'combined.mp4'
;
;   FRAMERATE = (Int) Default = 25
;
; CALLS: 
;   AIA_FFMPEG
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

if not keyword_set(framerate) then framerate = 25
if not keyword_set(fname) then fname='combine.mp4'

movie_arr = file_search(dir, '*.mp4')
n = n_elements(movie_arr)
tempdir = dir+'temp/'
file_mkdir, tempdir

for i=0, n-1 do spawn, 'ffmpeg -i '+movie_arr[i]+' '+tempdir+'movie'+trim(i, '(i3.3)')+'_%6d.png', result, errResult

aia_ffmpeg, tempdir, framerate=framerate, extension='png', fname=fname, dir_out=dir

file_delete, tempdir, /recursive

return
end
