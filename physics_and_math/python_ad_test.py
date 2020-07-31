from scipy.io import readsav
from scipy.stats.morestats import anderson_ksamp

var = readsav('python_ad_test.sav') 

result = anderson_ksamp([var.a,var.b])

file = open('python_ad_test.txt', 'w')
file.write('a2 = '+str(result[0])+' \n')
file.write('critical_values = '+str(result[1])+' \n')
file.write('significance_levels = [ 25% 10% 5% 2.5% 1%]'+' \n')
file.write('p = '+str(result[2])+' \n')
file.close()
