import numpy as np
import math  as m
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib.patches import Rectangle
import numpy as np
from matplotlib import rc
import seaborn as sns
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)
mpl.rcParams['axes.linewidth'] = 2
mpl.rcParams.update({'figure.autolayout': True})

for m in range(1,4):
	
	INPUT1  =  open("distances-" + str(m) + ".txt" , "r")
	lines1   = INPUT1.readlines()
	INPUT2  =  open("final-" + str(m) + ".txt" , "r")
	lines2   = INPUT2.readlines()

	T1 = np.zeros(len(lines1))
	X1 = np.zeros((len(lines1),2))

	T2 = np.zeros(len(lines2))
	X2 = np.zeros((len(lines2),2))

	for j in range(0, len(lines1)):
		line1  = lines1[j].split()
		T1[j] = float(line1[0])
		for k in range(0, 2):
			X1[j][k] = float(line1[k + 1])

	for j in range(0, len(lines2)):
		line2  = lines2[j].split()
		T2[j] = float(line2[0])
		for k in range(0, 2):
			X2[j][k] = float(line2[k + 1])

	C = 1.25
	fig, ax = plt.subplots()
	plt.plot(T1 * C, X1[:,0], linewidth = 4, color = 'salmon', alpha = 0.6)
	plt.plot(T2 * C, X2[:,0], linewidth = 3, color = 'darkred', label = r'$\textrm{Chain A}$')
	plt.plot(T1 * C , X1[:,1], linewidth = 4, color = 'cyan', alpha = 0.6)
	plt.plot(T2 * C, X2[:,1], linewidth = 3, color = 'blue', label = r'$\textrm{Chain B}$')
	ax.add_patch(Rectangle((0,0),80,30, facecolor = 'yellow', alpha = 0.3))
        

	plt.ylabel(r'$\textrm{Distance} \ (\mathrm{\AA})$', fontsize = 25)
	plt.xlabel(r'$\textrm{Time} \ \mathrm{( ns)}$', fontsize = 25)
	plt.xticks(fontsize = 25)
	plt.yticks(fontsize = 25)
	plt.ylim((0, 30))   # set the xlim to left, right
	plt.xlim((0, 1080))   # set the xlim to left, right
	plt.xticks(np.arange(80, 1080.1, 200),['$0$','$200$','$400$','$600$','$800$','$1000$'])
	plt.yticks(np.arange(0, 30.1, 10))
	#ax.set_xticklabels(['0','200','400','600','800','1000'])
	if m == 3:
		plt.legend(fontsize = 20, ncol = 1)

	plt.savefig("distances-" + str(m) + ".pdf")

	plt.close() 

