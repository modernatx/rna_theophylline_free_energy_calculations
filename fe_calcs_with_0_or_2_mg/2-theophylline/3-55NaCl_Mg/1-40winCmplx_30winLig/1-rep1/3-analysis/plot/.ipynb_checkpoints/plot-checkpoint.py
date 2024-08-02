import numpy as np
import math  as m
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib.patches import Rectangle
import numpy as np
from matplotlib import rc
import seaborn as sns
# rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
# rc('text', usetex=True)
# mpl.rcParams['axes.linewidth'] = 2
# mpl.rcParams.update({'figure.autolayout': True})

x1 = np.loadtxt('rna_bb_rmsd.dat')
t1 = np.arange(0,len(x1),1)

x2 = np.loadtxt('lig_rmsd.dat')
#x3 = np.loadtxt('Mg1_rmsd.dat')
#x4 = np.loadtxt('Mg2_rmsd.dat')

# T1 = np.zeros(len(lines1))

C = 0.5
fig, ax = plt.subplots()
plt.plot(t1 * C, x1[:,1], linewidth = 1, color = '#1f77b4', label = 'RNA backbone')
plt.plot(t1 * C, x2[:,1], linewidth = 1, color = '#d62728', label = 'ligand')
plt.plot(t1 * C, x3[:,1], linewidth = 1, color = '#ff7f0e', label = 'Mg 1')
plt.plot(t1 * C, x4[:,1], linewidth = 1, color = '#fdbf6f', label = 'Mg 2')

# 	plt.plot(T2 * C, X2[:,0], linewidth = 3, color = 'darkred', label = r'$\textrm{Chain A}$')
# 	plt.plot(T1 * C , X1[:,1], linewidth = 4, color = 'cyan', alpha = 0.6)
# 	plt.plot(T2 * C, X2[:,1], linewidth = 3, color = 'blue', label = r'$\textrm{Chain B}$')
ax.add_patch(Rectangle((0,0),214*C,30, facecolor = 'bisque', alpha = 0.3))
ax.add_patch(Rectangle((214*C,0),20*C,30, facecolor = 'rosybrown', alpha = 0.3))
ax.add_patch(Rectangle(((214+20)*C,0),160*C,30, facecolor = 'lavender', alpha = 0.3))
ax.add_patch(Rectangle(((214+20+160)*C,0),164*C,30, facecolor = 'lightpink', alpha = 0.3))
        

plt.ylabel(r'RMSD ($\AA$)', fontsize = 15)
plt.xlabel('Time (ns)', fontsize = 15)
plt.xticks(fontsize = 15)
plt.yticks(fontsize = 15)
plt.ylim((0, 4))   # set the xlim to left, right
plt.xlim((0, (214+20+160+164)*C))   # set the xlim to left, right
# 	plt.xticks(np.arange(80, 1080.1, 200),['$0$','$200$','$400$','$600$','$800$','$1000$'])
plt.yticks(np.arange(0, 4.1, 1))
# 	#ax.set_xticklabels(['0','200','400','600','800','1000'])
# 	if m == 3:
plt.legend(fontsize = 10, ncol = 1)

plt.savefig("rmsd" + ".pdf")

plt.close() 

