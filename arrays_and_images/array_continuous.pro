function array_continuous, array, allowance=allowance, extract=extract

; ========================================================================================
;+
; NAME: 
;	ARRAY_CONTINUOUS
;
; CATEGORY: 
;	Utilities
;
; PURPOSE: 
;	Locate the continuous segments of a 1D array. 
;
; CALLING SEQUENCE:
;	cont = array_continuous(ARRAY [,ALLOWANCE=float] [,EXTRACT=boolean] [,QUIET=boolean])
;
; INPUTS: 
;	ARRAY = 1-dimensional number array
;
; OUTPUTS: 
;	RETURN = 2-dimensional array of indicies [2,n_segments], where the first element 
;			 is the index corresponding to the start of a continuous segment, and the 
;			 second element is the index corresponding to the end of the same segment. 
;			 If the EXTRACT keyword is set, then the RETURN array will actually contain 
;			 the values of the input ARRAY that bookend the continuous segments. 
;         
; KEYWORDS: 
;	ALLOWANCE = Float, defaults to 1. By default, a "continuous" segment is one in each 
;				consecutive element is no more than 1 greater than the previous. Use the  
;				ALLOWANCE keyword to change gap allowance. 
;
;	EXTRACT = Boolean, defaults to 0. By default, the RETURN array contains index values 
;			  for indexing the input ARRAY. Set the EXTRACT keyword to instead return the 
;			  actual values of the input array that bookend continuous segments. 
;
; EXAMPLES:
;	IDL> array = [101,102,103,106,107,108,112,115,116,117,118,119]
;	IDL> print, array_continuous(array)          
;			   0           2
;			   3           5
;			   6           6
;			   7          11
;	IDL> print, array_continuous(array, /extract)                 
;		 101     103
;		 106     108
;		 112     112
;		 115     119           
;
; NOTES:
;	
;
; CALLS: 
;	None
;
; MODIFICATION HISTORY: 
;	 - 2016/10/12 - Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if n_elements(allowance) eq 0 then allowance = 1.

step = array[1:*] - array[0:n_elements(array)-2]
step = [0,step]

want = where(step gt allowance, nsets)

set_begin = [0,want]
set_end = [want-1, n_elements(array)-1]

if keyword_set(extract) then output = transpose([[array[set_begin]], [array[set_end]]], [1,0]) $
	else output = transpose([[set_begin], [set_end]], [1,0])

return, output
end
