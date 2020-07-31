function symlink_tester, paths, dangling=dangling, real=real, id=id, quiet=quiet

; ========================================================================================
;+
; NAME: 
;   SYMLINK_TESTER
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Test symlinks and return only the links that aren't dangling (i.e. the thing they 
;   point to is still there)
;
; INPUTS: 
;   PATHS = (String Array) List of symlinks to test
;
; OUTPUTS: 
;   RETURN = (String Array) List of good symlinks
;         
; KEYWORDS: 
;   DANGLING = (Long Array) Indices of PATHS that are dangling symlinks
;
;   REAL = (Long Array) Indices of PATHS that aren't dangling symlinks
;
;   ID = (String) String to add some more context to the printed messages (e.g. 
;        ID = 'AIA Files')
;
;   QUIET = (Boolean) Set to suppress messages
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

if not keyword_set(id) then id = ''

test = file_test(paths, /dangling_symlink)
dangling = where(test eq 1, count, complement=real)
if not keyword_set(quiet) then message, trim(count)+'/'+trim(n_elements(paths))+' of the '+id+' paths were dangling.', /informational 
if count eq n_elements(paths) then output = -1 else output = paths[real]

return, output
end
