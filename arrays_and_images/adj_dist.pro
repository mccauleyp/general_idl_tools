function adj_dist, x_coord, y_coord, nshift=nshift

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	ADJ_DIST
;
; CATEGORY: 
;	Image processing
;
; PURPOSE: 
;	Determine the physical distances between adjacent pixels in an irregular x/y grid 
;   to check the uniformity of the pixel scale. 
;
;INPUTS:
;	X_COORD = Float Array [Nx,Ny]. X coordinate image. The value of each pixel corresponds 
;             to its position on the grid. 
;
;	Y_COORD = Float Array [Nx,Ny]. Y coordinate image.
;
;OUTPUTS:
;	RETURN = Float Array [Nx,Ny]. Each pixel value corresponds to its distance relative 
;			 the adjacent pixels prescribed by the NSHIFT keyword. 
;
;KEYWORDS:
;	NSHIFT = Integer Array, Default = [0,1]. Number of directions to shift the coordinate 
;			 system (i.e. number of adjacent pixels considered). 0, 1, 2, and 3 will return
;			 the distances with respect to the adjacent right, upper, left, and lower 
;			 coordinates. If NSHIFT is an array (e.g. [0,1,2,3]) then the RETURN array 
;			 will be the average of the distances asked for. 
;
; CALLS: 
;   TRIM, SHIFT_IMG
;
;MODIFICATION HISTORY
;	2016/07/05 - Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if n_elements(x_coord) eq 0 OR n_elements(y_coord) eq 0 then begin
	message, 'Oops, missing input(s).', /info
	return, -1
endif

if n_elements(nshift) eq 0 then nshift = [0,1]
str_nshift = strjoin(trim(nshift),',')

if min(nshift) lt 0 OR max(nshift) gt 3 OR n_elements(nshift) gt 4 then begin
	message, 'Oops, NSHIFT out of bounds.', /info
	return, -1
endif

shifts = [[1,0],[0,1],[-1,0],[0,-1]]
shifts = shifts[*,nshift]

naxis = size(x_coord, /dimensions)
dist_arr = fltarr(naxis)

for j=0, n_elements(nshift)-1 do begin
	x_coord2 = shift_img(x_coord, shifts[*,j])
	y_coord2 = shift_img(y_coord, shifts[*,j])
	dist_arr = dist_arr+sqrt((x_coord-x_coord2)^2. + (y_coord-y_coord2)^2.)
endfor

;set edges to median value so they don't throw off the dist_arr image
if strpos(str_nshift, '0') ne -1 then dist_arr[0,*]=median(dist_arr)
if strpos(str_nshift, '1') ne -1 then dist_arr[*,0]=median(dist_arr)
if strpos(str_nshift, '2') ne -1 then dist_arr[naxis[0]-1,*]=median(dist_arr)
if strpos(str_nshift, '3') ne -1 then dist_arr[*,naxis[1]-1]=median(dist_arr)

;divide by the number of shifts to get average shift
dist_arr = dist_arr / n_elements(nshift)

return, dist_arr
end
