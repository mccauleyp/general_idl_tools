pro delete_imgs, thresh=thresh, test=test

; ========================================================================================
;+
; NAME: 
;   DELETE_IMGS
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Delete PNG and JP2 images from directory, optionally exclude directories interactively. 
;
; INPUTS: 
;   None
;
; OUTPUTS: 
;   None
;         
; KEYWORDS: 
;   THRESH = Int, minimum number of images for a directory to be considered
;
;   TEST = Boolean, set to print the list of files to be deleted, but don't actually 
;          delete them
;
; NOTES:
;   Intended for my filesystem, which often had large numbers of images produced 
;   for making movies of observations that I didn't want to delete immediately upon 
;   production. 
;
; CALLS: 
;   REMOVE, TRIM
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


if not keyword_set(thresh) then thresh=10

dir = '~/analysis/'

imgs = [file_search(dir, '*.png'), file_search(dir, '*.jp2')]

dirs = file_dirname(imgs)
udirs = dirs[uniq(dirs, sort(dirs))]

nimgs = lonarr(n_elements(udirs))
for i=0, n_elements(udirs)-1 do begin
	list = [file_search(udirs[i]+'/*.png'),file_search(udirs[i]+'/*.jp2')] 	
	nimgs[i] = n_elements(list)
endfor

want = where(nimgs gt thresh, count)

if count gt 0 then udirs = udirs[want] else begin
	message, 'No directories with more than '+trim(thresh)+' images.', /info
	return
endelse


for i=0, n_elements(udirs)-1 do print, i, '   ', udirs[i]

exclude = ''

read, exclude, prompt='Which directories should be excluded? '

if exclude eq 'abort' then begin
	message, 'Aborted, no images deleted', /info
	return
endif

if exclude ne '' then begin 
	exclude = fix(strsplit(exclude, ',', /extract)) 
	delete_dirs = udirs
	remove, exclude, delete_dirs
endif else delete_dirs = udirs

message, 'Deleting images from the following directories: ', /info

for i=0, n_elements(delete_dirs)-1 do begin
	list = [file_search(delete_dirs[i]+'/*.png'),file_search(delete_dirs[i]+'/*.jp2')] 
	list = list[where(list ne '')]
	print, trim(n_elements(list))+' images deleted from '+delete_dirs[i]
	if not keyword_set(test) then file_delete, list
endfor

return
end
