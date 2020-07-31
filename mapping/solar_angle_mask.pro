function solar_angle_mask, index, angles, radius, boolean_map=boolean_map, plot=plot, $
				x_img=x_img, y_img=y_img, r_img=r_img, psi_img=psi_img, rho_img=rho_img, $
				endpoints=endpoints, qstop=qstop

; ========================================================================================
;+
; PROJECT: 
;	MWA
;
; NAME: 
;	MWA_ANGLE_MASK
;
; CATEGORY: 
;	Image processing, Mapping
;
; PURPOSE: 
;	Identify pixels between two angles, measured counterclockwise from solar north. 
;	Optionally, filter pixels based on radial distance from Sun-center as well. 
;
; CALLING SEQUENCE:
;	pixels = solar_angle_mask(index, angles [,radius] [,boolean_img=byte array] 
;				[,plot=boolean] [,x_img=float array] [,y_img=float array] 
;				[,r_img=float array] [,psi_img=float array] [,rho_img=float array]
;				[,qstop=boolean]
;
; INPUTS: 
;	INDEX = Structure (FITS header)
;			FITS header containing solar imaging metadata.
;
;	ANGLES = Float or 2-element Float Array
;			[PSI_1, PSI_2], measured counterclockwise from solar north (0 to 360 deg)
;
;	RADIUS = (Optional) Float or 2-element Float Array 
;			[R_1, R_2], measured in solar radii from Sun-center. If one element is supplied, 
;			all pixels greater than that value will be returned. 
;
; OUTPUTS: 
;	RETURN = Long Array 
;			1D pixel subscripts, as in WHERE()
;
;	Optional keyword outputs:
;
;	BOOLEAN_IMG = Byte Array
;			Image of 1s and 0s, where 1s correspond to the selected pixels
;
;	BOOLEAN_MAP = Map Structure
;			Map structure based on INDEX with a data array containing 1s and 0s, 
;			where 1s correspond to the selected pixels
;
;	X_IMG = Float Array
;			Image containing the Solar X coordinates for each pixel in arcsec from Sun-center
;
;	Y_IMG = Float Array
;			Image containing the Solar Y coordinates for each pixel in arcsec from Sun-center
;	
;	R_IMG = Float Array
;			Image containing the radial distance in solar radii for each pixel 
;
;	PSI_IMG = Float Array
;			Image containing the PSI angle for each pixel from solar north (0 to 360 deg)  
;
;	RHO_IMG = Float Array
;			Image containing the RHO angular distance from Sun-center = 0 deg
;      
; KEYWORDS: 
;
;	PLOT = Boolean
;			Set to plot a map of BOOLEAN_IMG
;
;	QSTOP = Boolean
;			Pause before return for debugging
;	
;	
; EXAMPLES:
;	
;
; NOTES:
;	See Thompson 2006 for details on solar coordinates. This routine uses Helioprojective 
;	Cartesian and Helioprojective Radial coordinates.
;
; CALLS: 
;	FITSHEAD2WCS, WCS_GET_COORD, WCS_CONVERT_FROM_COORD, PB0R, WCS2MAP, PLOT_MAP
;
; MODIFICATION HISTORY: 
;	 - 2017/08/28 - Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if size(index, /tname) ne 'STRUCT' then begin
	message, 'Oops, INDEX should be a FITS header structure.', /info
	return, -1
endif

if n_elements(angles) eq 1 then psi_use = [angles[0], angles[0]] $
	else psi_use = angles
	
want = where(psi_use lt 0 OR psi_use gt 360, count)
if count gt 0 then begin
	message, 'Oops, ANGLES should range from 0 to 360, measured counter-clockwise from North.', /info
	return, -1
endif	

boolean_img = bytarr(index[0].naxis1, index[0].naxis2)	

wcs = fitshead2wcs(index[0]) ;HPC (arcsec) coordinate system

want = where(boolean_img eq 0) ;1d pixel locations
pixels = array_indices(boolean_img, want) ;pixel locations

coord = wcs_get_coord(wcs, pixels) ;HPC (arcsec) coords

x_img = fltarr(index[0].naxis1, index[0].naxis2)
y_img = x_img
r_img = x_img
psi_img = x_img
rho_img = x_img

;psi = counter clockwise angle around circle (north = 0)
;rho = angular distance from sun-center 
wcs_convert_from_coord, wcs, coord, 'HPR', psi, rho, /zero_center, /pos_long

sun_angles = pb0r(index[0].date_obs, /earth, l0=l0, /arcsec)
optical_limb_arcsec = [sun_angles[0], 0] ;[x = 1 R_sun, y = 0]

x_img[want] = coord[0,*]
y_img[want] = coord[1,*]
r_img = sqrt(x_img^2 + y_img^2) / sun_angles[2]
psi_img[want] = psi
rho_img[want] = rho

case n_elements(radius) of
	0: r_use = [0,max(r_img)]
	1: r_use = [radius, max(r_img)]
	2: r_use = radius
	else: begin
		message, 'Oops, RADIUS should have 1 or 2 elements.', /info
		return, -1
	endelse
endcase

if psi_use[0] gt psi_use[1] then begin
	mask_px = where((psi_img ge psi_use[0] AND psi_img le 360.) OR $
					(psi_img le psi_use[1] AND psi_img ge 0.) AND $
				 	(r_img ge r_use[0] AND r_img le r_use[1]), count)
endif else begin
	mask_px = where((psi_img ge psi_use[0] AND psi_img le psi_use[1]) AND $
				 	(r_img ge r_use[0] AND r_img le r_use[1]), count)
endelse

if count eq 0 then message, 'Oops, no pixels found in range.', /info else begin
	boolean_img[mask_px] = 1
	wcs_convert_to_coord, wcs, endpoints, 'HPR', angles, fltarr(2)+max(rho), /pos_long, /zero_center
endelse

wcs2map, boolean_img, wcs, boolean_map
if keyword_set(plot) then plot_map, boolean_map

if keyword_set(qstop) then stop

return, mask_px
end
