function flare_class_to_num, class

; ========================================================================================
;+
; PROJECT: 
;	mcCatalogs; Flare
;
; NAME: 
;	FLARE_CLASS_TO_NUM
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Convert flare class to a simple number for sorting. (A4.2 -> 0.42, M4.2 -> 3.42)
;
; CALLING SEQUENCE:
;	result = flare_class_to_num(class)
;
; INPUTS: 
;	CLASS - [Mandatory] (String)
;			Flare class, e.g. 'M4.2'
;	
; OUTPUTS: 
;	RETURN - [Mandatory] (Float)
;         	Number corresponding to flare class. A is 0., B is 1., C is 2., and so on. 
;
; KEYWORDS: 
;	None. 
;
; EXAMPLES:
;	IDL> number = flare_class_to_num('M4.2')
;	IDL> print, number
;	      3.42000
;
; NOTES:
;	This routine is only intended to be used for sorting purposes (and is a kludgey solution 
;	at that). Remember that the flare classes are logarithmic, so these numbers are not 
;	at all accurate representations of relative intensity. 
;
; MODIFICATION HISTORY: 
;	2013/05/03 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

for i=0, n_elements(class)-1 do begin

	case strmid(class[i],0,1) of
		'A': num = 0. + float(strmid(class[i], 1, strlen(class[i])-1))/10.
		'B': num = 1. + float(strmid(class[i], 1, strlen(class[i])-1))/10.
		'C': num = 2. + float(strmid(class[i], 1, strlen(class[i])-1))/10.
		'M': num = 3. + float(strmid(class[i], 1, strlen(class[i])-1))/10.
		'X': num = 4. + float(strmid(class[i], 1, strlen(class[i])-1))/10.
		else: begin
				box_message, ['Class not recognized. Check input']
				return, -1
			  end
	endcase
	
	if i eq 0 then numclass = num else numclass = [numclass,num]
	
endfor

return, numclass
end
