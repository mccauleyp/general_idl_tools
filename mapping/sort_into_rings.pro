function sort_into_rings, pixel_map, nrings=nrings, $
			min_r=min_r, max_r=max_r, min_x=min_x, max_x=max_x, min_y=min_y, max_y=max_y

; ========================================================================================
;+
; NAME: 
;   SORT_INTO_RINGS
;
; CATEGORY: 
;   Mapping, Array Operations
;
; PURPOSE: 
;   Sort a PIXEL_MAP into rings, where ring membership is determined by a pixel's 
;   distance using a linear relationship between the range of radii and number of rings/
;
; INPUTS: 
;   PIXEL_MAP = (Structure) Output from PIXEL_MAP
;
;   NRINGS = (Int) Number of rings desired
;
; OUTPUTS: 
;   RETURN = (Structure) Structure containing the ring membership info the following tags:
;             {NRINGS: Number of rings, 
;              RADII: Average radius for each ring, 
;              MIN_R: Min radius, MAX_R: Max radius,
;              MAX_X: Max X-coord, MIN_X: Min X-coord,
;              MAX_Y: Max Y-coord, MIN_Y: Min Y-coord, 
;              MASK: 1D subscripts for every pixel in the image
;              RING_NUMS: Ring membership values corresponding to MASK
;              RING_IMG: Array of the same dimensions as the original image, where the 
;                    value of each pixels corresponds to what ring it belongs to}
;
; KEYWORDS: 
;   NRINGS = (Int) Number of rings to use, default = (image width) / 6
;
;   MIN_R, MAX_R = (Float) Min/Max radius to consider in units of input PIXEL_MAP
;
;   MIN_X, MAX_X = (Float) Min/Max abs(x) to consider in units of input PIXEL_MAP
;
;   MIN_Y, MAX_Y = (Float) Min/Max abs(y) to consider in units of input PIXEL_MAP
;
; EXAMPLES:
;   ring_struct = sort_into_rings(pixel_map)
;   plot_image, ring_struct.ring_img
;   ring_subscripts = where(ring_struct.ring_img = 15)
;   single_ring_img = bytarr(size(ring_struct.ring_img, /dim))
;   single_ring_img[ring_subscripts] = 1
;   plot_image, single_ring_img
;
; NOTES:
;   See example above for how to return the 1D subscripts for pixels of a given ring. 
;
;   The MIN_R keyword can be used to, for instance, only begin the rings above the limb
;   if you're looking at a solar image, PIXEL_MAP is in R_Sun units, and MIN_R=1. 
;
;   The RING_WRAPPER routine can be used to combine this code with RING_METRICS to also 
;   return the min, max, mean, median, and stdev values for each ring.
;
; CALLS: 
;   DEFAULT
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


m = pixel_map

default, min_r, min(m.r)
default, max_r, max(m.r)
default, min_x, min(m.x)
default, max_x, max(m.x)
default, min_y, min(m.y)
default, max_y, max(m.y)

sz = size(m.r, /dim)
default, nrings, sz[0]/6

mask = where(m.r ge min_r AND m.r le max_r AND $
			 m.x ge min_x AND m.x le max_x AND $
			 m.y ge min_y AND m.y le max_y)


;Distance of the radial rings from the center 
radii  = dindgen(nrings)/(nrings-1)*max_r + min_r

;Coefficients of a linear relationship for deciding ring membership 
coef = poly_fit(radii,dindgen(nrings),1) 

;Determines which ring a given pixel belongs in. Each element corresponds to a pixel 
;ring_nums  = round((coef[0] + coef[1]*m.r[mask]) +0.5)
ring_nums  = fix((coef[0] + coef[1]*m.r[mask]) +0.5)

ring_img = intarr(sz)

ring_img[mask] = ring_nums

output = {nrings:nrings, radii:radii, $
		  min_r:min_r, max_r:max_r, min_x:min_x, max_x:max_x, min_y:min_y, max_y:max_y, $
		  mask:mask, ring_nums:ring_nums, ring_img:ring_img}

return, output
end
