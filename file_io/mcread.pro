pro mcread, file, index, data, inst=inst, cutout=cutout, normalized=normalized, nodata=nodata, $
	scaled=scaled

; ========================================================================================
;+
; NAME: 
;   McREAD
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Wrapper code to read images and header structures from several instruments and file 
;   formats that I commonly use (.fits, .sav, .jp2). Telescopes supported are AIA, HMI, 
;   XRT, MWA, EUVI, and MDI. If the file is a .sav, then the INDEX and DATA variables 
;   must be contained within it. 
;
; INPUTS: 
;   FILE = '/path/to/file.ext'
;
; OUTPUTS: 
;   INDEX = FITS header structure
;
;   DATA = 2D data array
;         
; KEYWORDS: 
;   
;   NODATA = just return INDEX, DATA undefined (faster read)
;
;   INST = Instrument string ID output
;
;   CUTOUT, NORMALIZED, SCALED = These are output info variables that I commonly include  
;       in my .sav files, which are usually cutout versions of larger images
;
; EXAMPLES:
;   mcread, 'aia.fits', index, data
;   mcread, 'xrt.fits', index, data
;   mcread, 'cutout.sav', index, data
;   mcread, 'compressed.jp2', index, data
;
; NOTES:
;
; CALLS: 
;   CONCAT_STRUCT, MWA_PREP, READ_SDO, AIA_PREP, READ_XRT, SECCHI_PREP, MDI_READ, JP2_READ
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================


if strpos(strlowcase(file[0]), '.fits') ne -1 OR strpos(strlowcase(file[0]), '.fts') then fits=1 else fits=0
if strpos(strlowcase(file[0]), '.sav') ne -1 then sav=1 else sav=0
if strpos(strlowcase(file[0]), '.jp2') ne -1 then jp2=1 else jp2=0

if sav eq 0 AND fits eq 0 AND jp2 eq 0 then begin
	message, 'Oops, could not interpret input filenames.', /info
	return
endif

;if fits eq 1 then if n_elements(inst) eq 0 then begin
;	message, 'Oops, must supply INST keyword if input is fits files.', /info
;	return
;endif

if sav eq 1 then begin 

	for i=0, n_elements(file)-1 do begin 
		restore, file[i]
	
		if n_elements(aia_index) gt 0 then index = aia_index
		if n_elements(aia_data) gt 0 then data = aia_data
	
		if n_elements(data) eq 0 OR n_elements(index) eq 0 then begin
			message, 'Oops, SAV files must contain INDEX and DATA variable.', /info
			return
		endif
		
		if i eq 0 then begin
			data_out = data
			index_out = index
		endif else begin
			data_out = [[[data_out]],[[data]]]
			index_out = concat_struct(index_out, index)
		endelse
	endfor
	
	data = data_out
	index = index_out
	
endif else if jp2 eq 1 then begin

	jp2_read, file, index, data, nodata=nodata

endif else begin

	if not keyword_set(inst) then begin	
		if strpos(strupcase(file[0]), 'AIA') ne -1 then inst = 'AIA'
		if strpos(strupcase(file[0]), 'XRT') ne -1 then inst = 'XRT'
		if strpos(strupcase(file[0]), 'HMI') ne -1 then inst = 'HMI'
		if strpos(strupcase(file[0]), 'EUB') ne -1 then inst = 'EUVI'
		if strpos(strupcase(file[0]), 'EUA') ne -1 then inst = 'EUVI'
		if strpos(strupcase(file[0]), 'M_96M') ne -1 then inst = 'MDI'
		
		if n_elements(inst) eq 0 then inst = ' '
		
	endif

	case inst of
		'MWA': mwa_prep, file, index, data
		'AIA': begin
				read_sdo, file, index, data, /uncomp_delete, /silent
				aia_prep, temporary(index), temporary(data), index, data, /quiet
			end
		'XRT': begin
				read_xrt, file, index, data
			end
		'EUVI': begin
				!quiet=1
				secchi_prep, file, index, data, /rotate_on, /rotcubic_on, /silent, /quiet
				!quiet=0
		end
		'MDI': begin
			!quiet=1
			mdi_read, file, index, data
			!quiet=0
			want = where(finite(data) eq 0, count, complement=comp)
			if count gt 0 then data[want] = min(data[comp])
		end
		else: begin
				message, 'No specific handling for INST='+INST+', returning MREADFITS result.', /info
				mreadfits, file, index, data
			end	
	endcase
endelse


return
end
