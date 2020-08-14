function n_smallest, data, n

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	N_SMALLEST
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Find the n smallest values in an array and return an array of indices, as if from 
;	WHERE(). 
;
; CALLING SEQUENCE:
;	smallest = n_smallest(data_array, n_want)
;
; INPUTS: 
;	DATA = [Mandatory] (Number Array)
;			Data array. Can be any type of number (byte, integer, float, etc)
;	N = [Mantatory] (Integer)
;		Number of indices to return. If N = 10, then the 10 smallest indices will be 
;		returned.
;
; OUTPUTS: 
;	RETURN = [Mandatory] (Integer Array)
;			Indices of the N smallest values, as if from WHERE(). 
;         
; KEYWORDS: 
;	None. 
;
; EXAMPLES:
;	data = indgen(20)
;	smallest = n_smallest(data, 5)
;	print, data[smallest]
;
; NOTES:
;	None.
;
; Written by ??? and modified/documented Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

  compile_opt strictarr

  ; use histogram to find a set with more elements than n 
  ; of smallest elements
  nData = n_elements(data)
  nBins = nData / n
  h = histogram(data, nbins=nBins, reverse_indices=ri)

  ; loop through the bins until we have n or more elements
  nCandidates = 0L
  for bin = 0L, nBins - 1L do begin
    nCandidates += h[bin]
    if (nCandidates ge n) then break
  endfor

  ; get the candidates and sort them
  candidates = ri[ri[0] : ri[bin + 1L] - 1L]
  sortedCandidates = sort(data[candidates])

  if n gt n_elements(candidates[sortedCandidates]) then $
  	output = (sort(data))[0:n-1L] $
  else $  
  	output = (candidates[sortedCandidates])[0:n-1L]
  
  ; return the proper n of them
  return, output
end
