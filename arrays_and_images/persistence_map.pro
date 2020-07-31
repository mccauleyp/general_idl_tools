function persistence_map, cube, headers, inst=inst, difference=difference, base_sum=base_sum, $
		low=low, plot=plot, cadence=cadence, normalize=normalize

; ========================================================================================
;+
; NAME: 
;   PERSISTENCE_MAP
;
; CATEGORY: 
;   Image Processing, Array Operations
;
; PURPOSE: 
;   Generate a maximum or minimum value "persistence map" from a 3D data cube of images.
;   The output image will contain the max or min value of every pixel across the set. 
;   This process represents feature evolution across the time series into one image. 
;
; INPUTS: 
;   CUBE = 3D image array [X,Y,Nimgs]
;
;   HEADERS = Structure array containing FITS header structures from the cube
;
; OUTPUTS: 
;   RETURN = 2D persistence map image array
;         
; KEYWORDS: 
;   LOW = Boolean, set for min value map instead of max value
;
;   DIFFERENCE = Boolean, set to perform a base difference operation, where the base is 
;                constructed from the summed and averaged CUBE
;
;   BASE_SUM = Int, Index of CUBE up to which the base differene should be computed (e.g. 
;              to subtract sum corresponding to a pre-eruption state)
;
;   NORMALIZE = Boolean, set to normalize everything by the maximum value
;
;   CADENCE = Int, default = 1, CADENCE = 2 means every 2nd image would be used
;
;   PLOT = Boolean, set to plot result
;
;   INST = Accepts 'AIA' or 'MWA' for some default plot settings, otherwise the raw 
;          map will be displayed without any scaling. 
;
; NOTES:
;   Concept taken from Thompson & Young (2016) 
;   https://iopscience.iop.org/article/10.3847/0004-637X/825/1/27
;
; CALLS: 
;   MCREAD, PLOT_IMAGE, AIA_SCL, PROGRESS_BAR
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


if size(cube, /tname) eq 'STRING' then begin
	inpt = 'STRING' 
	nframes = n_elements(cube)-1
endif else begin
	inpt = 'CUBE'
	if n_elements(headers) eq 0 then begin
		message, 'Oops, forgot HEADERS input.', /info
		return, -1
	endif
	sz = size(cube, /dimensions)
	nframes = sz[2]
	inst = strmid(headers[0].telescop, 0, 3)
endelse

if n_elements(cadence) eq 0 then cadence = 1

if keyword_set(difference) then begin
	if n_elements(base_sum) eq 0 then base_sum = 1 
	start_loop = base_sum+1
	for i=0, base_sum do begin
		if inpt eq 'CUBE' then data = cube[*,*,i] $
			else mcread, cube[i], index, data, inst=inst

		if n_elements(base) eq 0 then base = double(data) $
			else base = base+data
	endfor 
	
	base = base / start_loop
	if keyword_set(normalize) then base = base / max(base)
endif else start_loop = 0

for i=start_loop, nframes-1, cadence do begin

	if inpt eq 'CUBE' then begin 
		data = cube[*,*,i] 
		index = headers[i]
	endif else mcread, cube[i], index, data, inst=inst

	if keyword_set(normalize) then data = data/max(data)

	if keyword_set(difference) then begin
		if difference eq 1 then data = data - base else begin
			tmp = data
			data = data - base
			base = tmp
		endelse
	endif

	if n_elements(map) eq 0 then map = double(data) else begin
		if keyword_set(low) then map = map < data $
			else map = map > data
		noerase=1
	endelse
	
	if keyword_set(plot) then begin 
		case inst of 
			'AIA': plot_image, aia_scl(index, map), noerase=noerase
			'MWA': plot_image, map, noerase=noerase
			else: plot_image, map, noerase=noerase
		endcase
	endif
		
	if not keyword_set(quiet) then progress_bar, i, nframes-1
endfor

return, map
end
