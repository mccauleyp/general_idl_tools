function pixel_path, image, pixels, fit_dim, arclen=arclen, debug=debug, prompt=prompt, $
					adjoining=adjoining, adj_shift=adj_shift

; ========================================================================================
;+
; NAME: 
;   PIXEL_PATH
;
; CATEGORY: 
;   Image Processing, Height Time
;
; PURPOSE: 
;   Given a set of pixels that have been interactively selected by the user using 
;   PIXEL_SELECT, generate a smooth trajectory path with a polynomial fit and calculate 
;   the arclength along the path. 
;
; INPUTS: 
;   IMAGE = (2D Array) Image from which the pixels were selected
;
;   PIXELS = (2D int arr) [2,npx] x,y pixel coords (can be obtained from PIXEL_SELECT)
;
;   FIT_DIM = (Integer) Polynomial fit dimension
;
; OUTPUTS: 
;   RETURN = (Long Array) 1D subscripts of pixels locations in the smooth fit trajectory.
;            If the adjoining keyword is set, this will be a pointer array containing 
;            the results for multiple adjacent trajectories
;         
; KEYWORDS: 
;   ARCLEN = (Float Array) Output distances (arclength) along the trajectory in units 
;            of pixels. 
;
;   PROMPT = (Boolean) Set to enable a prompt that will allow you interactively modify 
;            the FIT_DIM input to achieve a better fit. 
;
;   ADJOINING = (Int) Number of adjacent adjoining paths the be included
;
;   ADJ_SHIFT = (Int) Number of pixels to separate adjoining paths
;
; NOTES:
;   This routine is a helper for the CURVED_SLICE() routine, which allows you to select 
;   a curved path through and image to characterize the motion of a feature along 
;   an arbitrary trajectory, as opposed to a linear one as in IMG_SLICE()
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

;First, test if x or y should be treated as the independent variable

redo:

fit_x = poly_fit(pixels[0,*], pixels[1,*], fit_dim, chisq=chisq_x)
fit_y = poly_fit(pixels[1,*], pixels[0,*], fit_dim, chisq=chisq_y)

if chisq_y gt chisq_x then begin 
	xp = pixels[0,*] & yp = pixels[1,*]
	flipped=0
	fit = fit_x
endif else begin
	xp = pixels[1,*] & yp = pixels[0,*]
	flipped=1
	fit = fit_y
endelse

if n_elements(adj_shift) eq 0 then adj_shift = 0

xlength = round(max(xp)) - round(min(xp)) +1
x = dindgen(xlength) + round(min(xp))

y = dblarr(n_elements(x))
for i=0, n_elements(fit)-1 do y = y + fit[i]*x^i

;Compute Distance Along Path
dx = dblarr(n_elements(x))
for i=0, n_elements(fit)-2 do dx = dx + (i+1)*fit[i+1]*x^i
integral = sqrt(1. + dx^2.)
arclen = fltarr(n_elements(x))
for i=0, n_elements(arclen)-1 do arclen[i] = total(integral[0:i])-integral[0]

;Sanity check to make sure I did the arclength calculation properly
if keyword_set(debug) then begin
	linear_dist = fltarr(n_elements(x))
	crvlen = fltarr(n_elements(x))
	for i=0, n_elements(arclen)-1 do begin 
		arclen[i] = total(integral[0:i])-integral[0]
		linear_dist[i] = sqrt((x[0]-x[i])^2. + (y[0]-y[i])^2.)
		case i of
			0: crvlen[i] = 0
			1: crvlen[i] = linear_dist[i]
			else: crvlen[i] = crvlength(x[0:i], y[0:i])
		endcase
	
		print,  'i='+trim(i)+$
				', x='+trim(x[i])+$
				', y='+trim(y[i])+$
				', arclen='+trim(arclen[i])+$
				', crvlen='+trim(crvlen[i])+$
				', linear='+trim(linear_dist[i])
	
	endfor
endif

;Get back to proper x,y that matches images
if flipped eq 1 then begin
	new_x = y & new_y = x
	x = new_x & y = new_y
endif

;------------------------------------------------------------
;We need to ensure that the distances are measured from the 
;first clicked point. 
;------------------------------------------------------------
  
p1 = [pixels[0,0], pixels[1,0]]
pn = [pixels[0,(n_elements(pixels)/2)-1], pixels[1,(n_elements(pixels)/2)-1]]

d1 = sqrt( (x[0]-p1[0])^2. + (y[0]-p1[1])^2. )
dn = sqrt( (x[0]-pn[0])^2. + (y[0]-pn[1])^2. )

;reverse distances if necessary
if dn le d1 then begin 
	x = reverse(x)
	y = reverse(y)
	arclen = reverse(abs(arclen - max(arclen)))
endif

;------------------------------------------------------------
;Now we need to get a WHERE statement output (PATH) for the 
;pixels in the slice, and then we need to make sure that 
;the WHERE output is sorted to match the ARCLEN distances.
;------------------------------------------------------------

img_dim = size(image, /dimensions)
mock_img = bytarr(img_dim)

px = round(x)
py = round(y)
mock_img[px, py] = 1

path = where(mock_img eq 1)
ind = array_indices(mock_img, path)
xc = reform(ind[0,*])
yc = reform(ind[1,*])

str_c1 = '('+trim(px)+','+trim(py)+')' ;reference coordinates that match ARLEN distances
str_c2 = '('+trim(xc)+','+trim(yc)+')' ;coordinates matching PATH WHERE statement

if array_equal(str_c1, str_c2) ne 1 then begin 
	;match, str_c1, str_c2, suba, subb, count=count
	match_ind = lonarr(n_elements(str_c1))
	for i=0, n_elements(match_ind)-1 do begin
		want = where(str_c1[i] eq str_c2, count)
		if count ne 1 then message, 'Needs fixing...'
		match_ind[i] = want[0]
	endfor

	if array_equal(str_c1, str_c2[match_ind]) ne 1 then message, 'Needs fixing...'

	path = path[match_ind]
endif

;------------------------------------------------------------
;Prompt to adjust fit dimensions.
;------------------------------------------------------------

if keyword_set(prompt) then begin
	new_dim = fit_dim
	repeat begin 
		window, 20, xsize=512, ysize=512
		plot_image, image
		plots, pixels, psym=6
		plots, x, y
		message, 'Current Fit Polynomial Order: '+trim(fit_dim), /info
		read, new_dim, prompt='New Fit Order (0 to exit):  ' 
		if new_dim ne 0 then begin
			fit_dim = new_dim
			goto, redo 
		endif
	endrep until new_dim eq 0
	wdelete, 20
endif

;------------------------------------------------------------
;Deal with adjoining slices. 
;------------------------------------------------------------

if keyword_set(adjoining) then begin

	;These are the distances along the slice that we want for the adjoining slices. So if 
	;the user asked for 4 adjoining slices with a spacing of 15 pixels, then we want slices at a 
	;distances of [-30, 15, 0, 15, 30] from the original slice. 
	
	lin_fit = poly_fit(pixels[0,*], pixels[1,*], 1)
	m = -1./lin_fit[1]
	theta = atan(m) ;radians
	
	if n_elements(adjoining) eq 1 then adjoining = [adjoining, 1.]
	dist_want = [-reverse((indgen(adjoining[0]/2)+1)*adjoining[1]), (indgen(adjoining[0]/2+1))*adjoining[1]]
	
	xdist = dist_want*cos(theta)
	ydist = dist_want*sin(theta)
		
	paths = ptrarr(n_elements(dist_want))
	dists = ptrarr(n_elements(dist_want))

	for i=0, n_elements(dist_want)-1 do begin
	
		these_pixels = float(pixels)
		
		these_pixels[0,*] = these_pixels[0,*] + xdist[i]
		these_pixels[1,*] = these_pixels[1,*] + ydist[i]
		
		this_path = pixel_path(image, these_pixels, fit_dim, arclen=this_arclen)
	
		paths[i] = ptr_new(this_path)
		dists[i] = ptr_new(this_arclen)
	
	endfor

	;slice_binner, {dummy:'dummy'}, image, paths, dists, mask_img=mask_img, mask_ind=mask_ind 

	;testing purposes...
	;tmp = image
	;for i=0, n_elements(paths)-1 do tmp[*paths[i]] = max(image)
	;tmp2 = image
	;tmp2[path] = max(image)

	path = paths
	arclen = dists

endif

return, path
end
