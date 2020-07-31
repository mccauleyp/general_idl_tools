PRO READSTRING,Filename,Array,MAXLINE=maxline

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	READSTRING
;
; CATEGORY: 
;	Text Processing
;
; PURPOSE: 
;	Read text file into a string array.
;
; CALLING SEQUENCE:
;	readstring, filename, array [,maxline=maxline]
;
; INPUTS: 
;	FILENAME - (String)
;			'/path/to/file.txt'
;
; OUTPUTS: 
;	ARRAY - (String Array)
;			String array with contents of file.
;         
; KEYWORDS: 
;	MAXLINE - (Number)
;			Maximum number of lines allowed, defaults to 50,000
;
; EXAMPLES:
;	IDL> readstring, filename, array
;
; NOTES:
;	None.
;
; MODIFICATION HISTORY: 
;   30 Jun. 1997 - Written.  RSH/HSTX
;   28 Jun. 2000 - Square bracket subscripts.  RSH
;	23 Oct. 2014 - Added consideration for blank file and some error handling. McCauley	
;
;-
; ========================================================================================

if file_test(filename) eq 0 then begin
	message, 'File does not exist: '+filename, /info
	array = ''
	return
endif

IF n_elements(maxline) LT 1 THEN maxline=50000D
array = strarr(maxline)
openr,lun,filename,/get_lun
line = ''
i=0D
WHILE NOT eof(lun) DO BEGIN
    readf,lun,line
    array[i] = line
    i = i + 1
ENDWHILE

if i eq -1 then begin
	array = ''
	message, 'File is empty: '+filename, /info
endif else begin
	i = i - 1
	array = array[0:i]
endelse

free_lun,lun
RETURN
END
