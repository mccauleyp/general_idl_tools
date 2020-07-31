function array_indices_1d, array, indices, qstop=qstop, method=method

; ========================================================================================
;+
; NAME: 
;	ARRAY_INDICES_1D
;
; CATEGORY: 
;	Array operations
;
; PURPOSE: 
;	Perform inverse operation of the ARRAY_INDICES function, i.e., given 2D locations 
;   (coordinates), return 1D subscripts (as if returned from the WHERE function)
;
; INPUTS: 
;	ARRAY = [x_size, y_size] dimensions of the array you want subscripts for
;
;   INDICES = [2, N] array of locations (e.g. pixel coordinates) in the array that 
;             you want to convert to 1D subscripts
;
; OUTPUTS: 
;   RETURN = Long array of 1D subscripts (as if returned from WHERE function)	        
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if n_elements(array) eq 2 then sz = array else sz = size(array, /dimensions)

blank = bytarr(sz)

if n_elements(method) eq 0 then method=0

case method of

	0:begin

		one_dim = lonarr(n_elements(indices)/2)
		for i=0, n_elements(indices)/2 -1 do begin
			if indices[0,i] gt (sz[0]-1) OR indices[1,i] gt (sz[0]-1) then one_dim[i] = -1 else begin	
				blank[indices[0,i], indices[1,i]] = 1
				want = where(blank gt 0, count)
				if count ne 1 then stop
				one_dim[i] = want[0]
				blank = blank*0
			endelse
		
		endfor
		
	end
	
	;experimental, doesn't work as is and never updated
	1: begin
	
		blank[indices[0,*], indices[1,*]] = 1

		one_dim = where(blank eq 1)	
		
	end

endcase

if keyword_set(qstop) then stop

return, one_dim
end
