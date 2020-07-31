pro sort_data, list, copy, test=test, data_dir=data_dir, tmp_dir=tmp_dir, $
				inst_only=inst_only, overwrite=overwrite

; ========================================================================================
;+
; NAME: 
;   SORT_DATA
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Sort FITS files downloaded into a temporary staging directory into a specific 
;   directory structure based on the instrument. Files can be downloaded using 
;   VSO_DOWNLOAD. This routine currently supports AIA, XRT, HMI, EUVI_A/B, and MDI, 
;   but others could be added easily. 
;
; INPUTS: 
;   None. Files will automatically be located within DATA_DIR+'/tmp/'
;
; OUTPUTS: 
;   LIST = (Sring Array) List of files in staging directory
;
;   COPY = (String Array) List of filepaths where LIST will be moved to
;         
; KEYWORDS: 
;   TEST = (Boolean) Set to not actually move the files, just return LIST and COPY
;
;   DATA_DIR = (String) '/path/to/your/data/', default = getenv('DATA_DIR')
;
;   TMP_DIR = (String) staging directory where files were downloaded to 
;             default = DATA_DIR+'/tmp/'
;
;   INST_ONLY = (String) Set to only sort data from a particular instrument (e.g. 'AIA'
;
;   OVERWRITE = (Boolean) Default=1. Set to 0 to avoid overwriting files already in
;               your database, in which case they will remain in TMP_DIR
;
; NOTES:
;   Data can downloaded using VSO_DOWNLOAD. The directory structure can then be searched 
;   using AIA_SEARCH, STEREO_SEARCH, etc. 
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


if n_elements(overwrite) eq 0 then overwrite=1

if not keyword_set(data_dir) then begin 
	data_dir = getenv('DATA_DIR')
	if file_test(data_dir, /dir) eq 0 then data_dir = getenv('AUX_DATA_DIR')
	if file_test(data_dir) eq 0 then data_dir = '~/'
endif

if not keyword_set(tmp_dir) then tmp_dir = data_dir+'/tmp'

list = file_search(tmp_dir+'/*.f*')

;check for temporary files
tmp = where(strmid(list, 1, 2, /reverse) eq '_t', count, complement=non_tmp)
if count gt 0 then begin
	if count eq n_elements(list) then list[0] = '' $
		else list = list[non_tmp]
endif 

if list[0] eq '' then begin 
	message, 'No files to sort in '+tmp_dir, /info
	return
endif

bases = file_basename(list)

copy_fnames = strarr(n_elements(bases))
copy_dirs = strarr(n_elements(bases))
copy_insts = strarr(n_elements(bases))

for i=0, n_elements(bases)-1 do begin

	inst = '' ;initialise/reset inst
	b = strupcase(bases[i])
	if strpos(b, 'AIA') ne -1 then inst = 'AIA'
	if strpos(b, 'XRT') ne -1 then inst = 'XRT'
	if strpos(b, 'HMI') ne -1 then inst = 'HMI'
	if strpos(b, 'EUB') ne -1 OR strpos(b, 'EUA') ne -1 then inst = 'EUVIA_B'
	if strpos(b, 'M_96M') ne -1 then inst = 'MDI'

	if keyword_set(inst_only) then begin
		if inst ne strupcase(inst_only) then goto, skippy
	endif

	;IF data is from AIA

	case inst of
		'AIA': begin
			banana = strsplit(bases[i], '.', /extract)
			tsplit = strsplit(banana[2], '_')
			wavelength = trim(str_replace(strmid(banana[2], tsplit[0], tsplit[1]-1), 'A', ''), '(I4.4)')
		
			time = strmid(banana[2], tsplit[1])
			time_dir = str_replace(str_replace(strmid(time, 0, 13), '-', '/'), 'T', '/H')+'00'
		
			time_fname = str_replace(str_replace(str_replace(time, '-', ''), '_', ''), 'T', '_')
		
			fname = inst+time_fname+'_'+wavelength+'.fits'
		
			copy_dir = data_dir+'/SDO/AIA/level1/'+time_dir+'/'
	
			copy_dirs[i] = copy_dir
			copy_fnames[i] = fname
		end
		'XRT': begin
			b = bases[i]
			time_dir = strmid(b, 6, 4)+'/'+strmid(b, 10, 2)+'/'+strmid(b, 12, 2)+'/H'+strmid(b, 15, 2)+'00'
			copy_dir = data_dir+'/Hinode/XRT/'+time_dir+'/'
			copy_dirs[i] = copy_dir
			copy_fnames[i] = b
		end
		'HMI': begin
			b = bases[i]
			time_dir = strmid(b, 10, 4)+'/'+strmid(b, 15, 2)+'/'+strmid(b, 18, 2)+'/H'+strmid(b, 21, 2)+'00'
			copy_dir = data_dir+'/SDO/HMI/'+time_dir+'/'
			copy_dirs[i] = copy_dir
			copy_fnames[i] = b
		end
		'EUVIA_B': begin
			b = bases[i]
			time_dir = strmid(b, 0, 4)+'/'+strmid(b, 4, 2)+'/'+strmid(b, 6, 2)+'/H'+strmid(b, 9, 2)+'00'
			copy_dir = data_dir+'/SOHO/MDI/'+time_dir+'/'
			copy_dirs[i] = copy_dir
			copy_fnames[i] = b
		end
		'MDI': begin
			b = bases[i]
			t1 = anytim('1993-01-01T00:00:00.000')
			day = strmid(stregex(b, 'd.[0-9]{4}', /extract), 2, 4)
			day = anytim(t1 + float(day)*86400., /ccsds)
			time_dir = strmid(day, 0, 4)+'/'+strmid(day, 5, 2)+'/'+strmid(day, 8, 2)
			copy_dir = data_dir+'/SOHO/MDI/'+time_dir+'/'
			copy_dirs[i] = copy_dir
			copy_fnames[i] = b
		end
		else: begin
			message, 'Oops, handling only for AIA, XRT, HMI, EUVI(A/B), MDI (96m) so far.', /info
		end
	endcase

	skippy:

endfor

copy = copy_dirs+copy_fnames

want = where(copy ne '', count, complement=not_moved)

if count gt 0 then begin
	if not keyword_set(test) then begin
		copy_dirs = copy_dirs[want]
		mk_dirs = copy_dirs[uniq(copy_dirs, sort(copy_dirs))]
		for i=0, n_elements(mk_dirs)-1 do $
			if file_test(mk_dirs[i], /dir) eq 0 then file_mkdir, mk_dirs[i]
		file_move, list[want], copy[want], overwrite=overwrite	
	endif
	message, 'Moved the following files...', /info
	print, list[want]+' --> '+copy[want]
endif else begin
	message, 'No files moved.', /info
endelse

if not_moved[0] ne -1 then begin
	message, trim(n_elements(not_moved))+' files remaining in '+tmp_dir, /info
endif

return
end
