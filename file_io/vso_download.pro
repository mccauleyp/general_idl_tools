
;-----------------------------------------------------------------------------------------

pro vso_download, t1, t2, inst, wave=wave, physobs=physobs, detector=detector, $
					source=source, instrument=instrument, no_local_check=no_local_check, $
					data_dir=data_dir

;0105-0130 UT
;t1 = '2011/09/25 01:00:00'
;t2 = '2011/09/25 01:35:00'

;Souce = 'STEREO_A, STEREO_B'

possible_sources = ['BBSO', 'KANZ', 'OACT', 'OBSPM', 'YNAO', 'MLSO', 'SMM', 'SDO', 'ChroTel', $
					'RHESSI', 'Hi-C', 'YOHKOH', 'MtWilson', 'GOES-12', 'Evans', 'GONG', $
					'IVM', 'KPVT', 'McMath', 'PTMC', 'SOLIS', 'Nancay', 'OBSPM', $
					'Pic du Midi', 'OMP', 'OVRO', 'PROBA2', 'Hinode', 'SOHO', 'TRACE', $
					'SFO', 'SOHO', 'STEREO_A', 'STEREO_B']
					
possible_inst = ['BBSO', 'KANZ', 'OACT', 'OBSPM', 'YNAO', $ ;same as source
				 'chp', 'dpm', 'mk3', 'mk4', $ ;MLSO
				 'cp', $ ;SMM
				 'AIA', 'HMI', 'EVE', $ ;SDO
				 'ChroTel', 'RHESSI', 'Hi-C', $ ;same as source
				 'BCS', 'HXT', 'SXT', 'WBS', $ ;YOHKOH
				 '60-ft SHG', $ ;MtWilson
				 'SXI-0', $ ;GOES-12
				 'spectroheliograph', $ ;Evans
				 'Big Bear', 'Cerro Tololo', 'El Teide', 'Learmonth', 'MERGED GONG', 'Mauna Loa', 'Udaipur', $ ;GONG
				 'IVM', $ ;same as source
				 '512-channel magnetograph', 'spectromagnetograph', $ ;KPVT
				 'solar fts spectrometer', $ ;McMath
				 'PTMC', $ ;same as source
				 'ISS', 'vsm', $ ;SOLIS
				 'Decametric Array', 'Radioheliograph', $ ;Nancay
				 'Meudon Spectroheliograph', $ ;OBSPM
				 'Coronagraph', $ ;Pic du Midi
				 'CLIMSO', $ ;OMP
				 'OVSA', $ ;OVRO
				 'SWAP', $ ;PROBA2
				 'XRT', 'EIS', 'SOT', $ ;Hinode
				 'CDS', 'CELIAS', 'COSTEP', 'EIT', 'ERNE', 'GOLF', 'LASCO', 'MDI', 'SUMER', 'SWAN', 'UVCS', 'VIRGO', $ ;SOHO
				 'TRACE', $ ;TRACE
				 'CFDT1', 'CFDT2', $ ;SFO
				 'IMPACT', 'PLASTIC', 'SECCHI', 'SWAVES'] ;STEREO_A and STEREO_B
				 

if anytim(t1) ge anytim(t2) then begin
	message, 'Oops, T1 >= T2', /info
	return
endif

if not keyword_set(data_dir) then begin 
	data_dir = getenv('DATA_DIR')
	if file_test(data_dir, /dir) eq 0 then data_dir = getenv('AUX_DATA_DIR')
	if file_test(data_dir) eq 0 then data_dir = '~/'
endif

tmp_dir = data_dir+'/tmp'
if file_test(tmp_dir, /dir) eq 0 then file_mkdir, tmp_dir

if strlowcase(inst) eq 'aia' then begin
	if not keyword_set(wave) then $
		wavelengths = [171, 193, 304, 094, 131, 211, 335, 1600, 1700, 4500] $
	else $
		wavelengths = wave
		
	for i=0, n_elements(wavelengths)-1 do begin 
	
		message, 'Working on AIA/'+trim(wavelengths[i]), /info
		
		list = vso_search(t1, t2, inst='aia', wave=wavelengths[i], count=count, detector=detector, source=source)
		vso_times = strmid(anytim(list.time.start, /ccsds), 0, 19)
		
		if not keyword_set(no_local_check) then begin 
			sort_data, inst_only='AIA'
			local_files = aia_search(t1, t2, wavelengths[i], times=tim, limit=0)
			if size(local_files, /tname) eq 'POINTER' then begin
				local_times = strmid(anytim(*tim[0], /ccsds), 0, 19)
				match, vso_times, local_times, suba, subb
				if suba[0] ne -1 then begin
					if n_elements(suba) eq n_elements(vso_times) then begin
						message, 'All '+trim(n_elements(suba))+' '+trim(wavelengths[i])+' files already downloaded.', /info
						list = -1
					endif else begin 
						message, 'Removed '+trim(n_elements(suba))+' '+trim(wavelengths[i])+' pre-existing local files from download queue.', /info
						remove, suba, list
					endelse
				endif
			endif
		endif
		
		if size(list, /tname) eq 'STRUCT' then begin
			get = vso_get(list, /rice, filenames=filenames, /force, out_dir=tmp_dir, nodownload=nodownload)
		endif
				
	endfor

endif else begin 

	list = vso_search(t1, t2, inst=inst, wave=wave, physobs=physobs, detector=detector, source=source, count=count)
	
	if strlowcase(inst) eq 'secchi' then begin
		want = where(strpos(list.info, 'NORMAL') ne -1 AND list.dark eq 0, count)
		if count eq 0 then begin
			message, 'No images found for INST='+inst, /info
			return
		endif
		list = list[want]
	endif
		
	get = vso_get(list, /rice, filenames=filenames, /force, out_dir=tmp_dir, nodownload=nodownload)

endelse

heap_gc

return
end
