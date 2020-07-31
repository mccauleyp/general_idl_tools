function python_ad_test, a, b, dir=dir

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	PYTHON_AD_TEST
;
; CATEGORY: 
;	Utility, Math, Statistics
;
; PURPOSE: 
;	Perform a 2-sample Anderson Darling test using a Python script. 
;
; CALLING SEQUENCE:
;	struct = python_ad_test(a, b [,dir=dir])
;
; INPUTS: 
;	A = [Number Array]
;		Sample to be compared to B. 
;	B = [Number Array]
;		Sample to be compared to A. Need not have the same number of elements. 
;
; OUTPUTS: 
;	RETURN = (Structure)
;         
; KEYWORDS: 
;	DIR = (String)
;		'/path/to/python_ad_test/', defaults to '/data/jannah/mcCatalogs/code/idl/misc/python_ad_test/'
;
; EXAMPLES:
;	
;
; NOTES:
;	A and B will be stored in a save file called python_ad_test.sav in the DIR directory. 
;	This file will be read by the Python script python_ad_test.py, which then calls 
;	the anderson_ksamp function from scipy.stats.morestats. Then entirety of the python 
;	script is thus:
; 
;		from scipy.io import readsav
;		from scipy.stats.morestats import anderson_ksamp
;
;		var = readsav('python_ad_test.sav') 
;
;		result = anderson_ksamp([var.a,var.b])
;
;		file = open('python_ad_test.txt', 'w')
;		file.write('a2 = '+str(result[0])+' \n')
;		file.write('critical_values = '+str(result[1])+' \n')
;		file.write('significance_levels = [ 25% 10% 5% 2.5% 1%]'+' \n')
;		file.write('p = '+str(result[2])+' \n')
;		file.close()
;
;	Used by FILAMENT_PAPER_FIGURES, FILAMENT_KS_TEST, and FILAMENT_STATS_PLOTS
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

;if not keyword_set(dir) then dir = '/data/jannah/mcCatalogs/code/idl/misc/python_ad_test/'
which, 'python_ad_test', /quiet, outfile=outfile
dir = file_dirname(outfile)+'/'

save, a, b, filename=dir+'python_ad_test.sav'

cd, current=current
cd, dir

	spawn, 'python python_ad_test.py', result, errResult
	readstring, 'python_ad_test.txt', lines

cd, current

a2 = float((strsplit(lines[0], '=', /extract))[1])
crit = float(strsplit(trim(str_replace(str_replace((strsplit(lines[1], '=', /extract))[1], '[', ''), ']', '')), ' ', /extract))
sig = strsplit(trim(str_replace(str_replace((strsplit(lines[2], '=', /extract))[1], '[', ''), ']', '')), ' ', /extract)
p = float((strsplit(lines[3], '=', /extract))[1])
if total(strpos(errResult, 'extrapolation')) gt 0 then extrap = 'Y' else extrap = 'N'

readme = ['a2 = Anderson-Darling k-sample statistics (A^2)', 'p = approximate p-value at which null hypothesis can be rejected', $
		'sig = significance levels for critical values', 'crit = critical values for significance levels', $
		'extrap = Y if p-value is extrapolated from Scholz and Stephens (1987) table and N if it is interpolated' ]

output = {a2:a2, p:p, sig:sig, crit:crit, extrap:extrap, readme:readme}

return, output
end
