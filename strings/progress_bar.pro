pro progress_bar, current_iteration, loop_length, increment, no_escape=no_escape

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	PROGRESS_BAR
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Provide a nice progress bar for routines with long FOR loops. 
;
; CALLING SEQUENCE:
;	progress_bar, current_iteration, loop_length [,increment] [,/no_escape]
;
; INPUTS: 
;	CURRENT_ITERATION - (Integer)
;					Current loop index variable. 
;	LOOP_LENGTH - (Integer)
;					Loop length
;	INCREMENT - (integer)
;					Step size for loop iteration for loops that structure like so:
;					for i=0, 99, 10 do begin
;
; OUTPUTS: 
;	None. Progress bar will be printed. 
;         
; KEYWORDS: 
;	NO_ESCAPE - (Boolean)
;			By default, this routine will print an extra space when the progress bar 
;			reaches 100% to escape the line. This keyword disables that and may be useful 
;			if your loop advances in an unusual way through modifications of the loop 
;			variable within the loop, in which case you'd just want to print the escape 
;			space after the loop ends. Probably you won't need this. 
;
; EXAMPLES:
;	IDL> for i=0D, 999999, 10 do progress_bar, i, 999999, 10
;	100% |**********************************************************************|
;
; NOTES:
;	None. 
;
; MODIFICATION HISTORY: 
;	2014/10/13 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if n_elements(current_iteration) eq 0 OR n_elements(loop_length) eq 0 then begin
	message, 'Oops, missing input.', /info
	return
endif

if n_elements(increment) eq 0 then increment = 0.

if current_iteration+increment gt loop_length then progress=1 else progress = float(current_iteration)/loop_length  

print, strjoin(replicate(string(8B),77)), $
	 round(progress*100.), $
	 strjoin(replicate('*',(round(progress*70) > 1))) ,$
	 format="($,A77,I3,'%',1x,'|',A-70,'|')"

if not keyword_set(no_escape) then if progress eq 1 then print, ' '

end
