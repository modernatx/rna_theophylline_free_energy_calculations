import numpy as np
import math  as m
import matplotlib.pyplot as plt
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)
import sys

from scipy.special import rel_entr
from scipy.interpolate import splev, splrep

## espsilon to smooth the pdf and avoid pdf = 0 which gives inf for D_KL
eps = 1E-10

## Defining the range of lambda values for the even schedule
y = np.linspace(1,0,41)

## arrays to keep values of D_KL and Hellinger distance for 40 lamda windows
kl = np.zeros(40)
hell = np.zeros(40)

## Loop over the range of lambda values
for i in range(1,41):
    ## Reading the forward and backward data from files
    forward = np.loadtxt('file%d.dat.hist' %i, usecols = (0,1))
    backward = np.loadtxt('file%d.dat.rev.hist' %i, usecols = (0,1))
    
    ## Plotting the forward and backward data
    fig, axs = plt.subplots(1, 1, figsize=(5, 5))
    plt.plot(backward[:,0],backward[:,1], color='b'
             ,label=r'$\lambda$=%.3f'%y[i-1])
    plt.plot(forward[:,0],forward[:,1], color='r',
            label=r'$\lambda$=%.3f'%y[i])
    
    
    ## Splitting the forward and backward data into x and y
    x_bwd = backward[:,0]
    y_bwd = backward[:,1]
    x_fwd = forward[:,0]
    y_fwd = forward[:,1]
    ## Getting the minimum and maximum values of x for forward and backward data
    x_min_fwd = x_fwd.min()
    x_max_fwd = x_fwd.max()
    x_min_bwd = x_bwd.min()
    x_max_bwd = x_bwd.max()
    
    ## Defining x range for the fitted B-spline 
    xmin_overlap = np.maximum(x_min_fwd,x_min_bwd)
    xmax_overlap = np.minimum(x_max_fwd,x_max_bwd)
    xmin_overall = np.minimum(x_min_fwd,x_min_bwd)
    xmax_overall = np.maximum(x_max_fwd,x_max_bwd)
    x_all = np.linspace(xmin_overall, xmax_overall, 200)    
    
    ## Fitting B-spline to backward data
    spl_bwd = splrep(x_bwd,y_bwd)   
    y_bwd_new = splev(x_all, spl_bwd)
    
    ## Fitting B-spline to forward data        
    spl_fwd = splrep(x_fwd,y_fwd)
    y_fwd_new = splev(x_all, spl_fwd)
    
  
    ## Setting the values outside the range of x to epsilon
    for j in range(len(x_all)):
        if x_all[j] < x_min_bwd:
            y_bwd_new[j] = eps
        elif x_all[j] > x_max_bwd:
            y_bwd_new[j] = eps        
        if x_all[j] < x_min_fwd:
            y_fwd_new[j] = eps
        elif x_all[i] > x_max_fwd:
            y_fwd_new[j] = eps
            
    ## Replacing any negative values with epsilon
    y_fwd_new = np.where(y_fwd_new < 0, eps, y_fwd_new) 
    y_bwd_new = np.where(y_bwd_new < 0, eps, y_bwd_new)
    
    ## Re-normalizing the distribution after adding the epsilon
    fwd_eps = len(np.where(y_fwd_new == eps)[0])
    fwd_no_eps = len(y_fwd_new) - fwd_eps
    y_fwd_new = np.where(y_fwd_new != eps, y_fwd_new-fwd_eps*eps/fwd_no_eps, y_fwd_new)

    bwd_eps = len(np.where(y_bwd_new == eps)[0])
    bwd_no_eps = len(y_bwd_new) - bwd_eps
    y_bwd_new = np.where(y_bwd_new != eps, y_bwd_new-bwd_eps*eps/bwd_no_eps, y_bwd_new)

    ## during re-normalization some parts turn <0 and need to be replaced by eps
    y_fwd_new = np.where(y_fwd_new < 0, eps, y_fwd_new) 
    y_bwd_new = np.where(y_bwd_new < 0, eps, y_bwd_new)    


    
    ## calc continus KL
    kl_pq_1 = rel_entr(y_bwd_new,y_fwd_new)
    kl_1 = np.trapz(kl_pq_1, x_all)
    kl_pq_2 = rel_entr(y_fwd_new,y_bwd_new)
    kl_2 = np.trapz(kl_pq_2, x_all)    
    kl[i-1] = .5*(kl_1+kl_2)
    
    ## calc continus Hellinger distance
    hell[i-1] = np.sqrt(np.trapz((np.sqrt(y_fwd_new)-np.sqrt(y_bwd_new)) ** 2, x_all) / 2)    
    
    ## setting the parameters for the plots
    ymin,ymax = axs.get_ylim()
    axs.set_yticks(np.arange(0, ymax, 0.5),fontsize=14)
    xmin,xmax = axs.get_xlim()
    axs.set_xticks(np.arange(m.floor(xmin), xmax, 2),fontsize=14)

    axs.xaxis.set_minor_locator(MultipleLocator(1))
    axs.yaxis.set_minor_locator(MultipleLocator(.25))

    axs.set(xlim=(xmin, xmax), ylim=(0, ymax))
    axs.tick_params(direction='out', length=6, width=1.25)
    axs.tick_params(direction='out', which='minor' ,length=3, width=1.25)
    
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)

    plt.plot([],[], color='k',
            label=r'$D_{KL}$=%.1f'%kl[i-1] +r', H=%.1f' %hell[i-1])
    l = axs.legend(handlelength=0, handletextpad=0,
                              labelcolor='linecolor',fontsize=20, 
                              loc='upper right')
    for item in l.legendHandles:
        item.set_visible(False) 

    plt.savefig(f"./figs/win_%02d.pdf" %i, bbox_inches='tight')
    
    ## Plotting the B-spline fit forward and backward data
    plt.plot(x_all, y_bwd_new, label='estimated bwd')
    plt.plot(x_all, y_fwd_new, label='estimated fwd')
    plt.savefig(f"./figs/win_Bspline_%02d.pdf" %i, bbox_inches='tight')
    plt.close()

## barplot for all D_KL of all windows
fig, axs = plt.subplots(1, 1, figsize=(5, 5))
x = np.arange(1,len(kl)+1)
# Color the bars higher than 2 with a different color
barlist = plt.bar(x,kl)
for i in range(len(kl)):
    if kl[i] > 2:
        barlist[i].set_color('#ff0000') # set the color to red
    else:
        barlist[i].set_color('#86bf91') # set the color to green

plt.plot([],[], color='k',
            label=r'$<D_{KL}>$=%.1f'%np.mean(kl))        
l = axs.legend(handlelength=0, handletextpad=0,
                              labelcolor='linecolor',fontsize=20, 
                              loc='upper right')
for item in l.legendHandles:
    item.set_visible(False)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.xlabel(r'$\lambda$ window', fontsize=17)
plt.ylabel(r"$D_{KL}$", fontsize=17)
plt.xlim((0,41))
plt.ylim((0,18))
# plt.grid(visible=True, linestyle='-.')
plt.subplots_adjust(bottom=0.25, left=0.25)
# plt.xticks(rotation=45)
plt.axhline(y=2, color='black', linestyle='-') # Add a horizontal line at 2
plt.savefig(f"./figs/bar_D_KL.pdf", bbox_inches='tight')
plt.close()

## barplot for all Hellinger dis of all windows
fig, axs = plt.subplots(1, 1, figsize=(5, 5))
x = np.arange(1,len(hell)+1)
# Color the bars higher than .5 with a different color
barlist = plt.bar(x,hell)
for i in range(len(hell)):
    if hell[i] > .5:
        barlist[i].set_color('#ff0000') # set the color to red
    else:
        barlist[i].set_color('#86bf91') # set the color to greenplt.xticks(fontsize=14)
plt.plot([],[], color='k',
            label=r'<H>=%.1f'%np.mean(hell))
l = axs.legend(handlelength=0, handletextpad=0,
                              labelcolor='linecolor',fontsize=20, 
                              loc='upper right')
for item in l.legendHandles:
    item.set_visible(False)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.xlabel(r'$\lambda$ window', fontsize=17)
plt.ylabel(r"Hellinger distance", fontsize=17)
plt.xlim((0,41))
plt.ylim((0,1))
plt.subplots_adjust(bottom=0.25, left=0.25)
plt.axhline(y=.5, color='black', linestyle='-') # Add a horizontal line at 2
plt.savefig(f"./figs/bar_H.pdf", bbox_inches='tight')
plt.close()

with open('KL_Hell_bar_values.txt', 'w') as f:
    sys.stdout = f
    for row in zip(x, kl, hell):
        print (*row, sep='\t')
############### PLOT ALL

# create a figure with 10 rows and 4 columns for subplots
fig, axs = plt.subplots(10, 4, figsize=(15, 30))

# loop through each subplot 
for i in range(0,40):
    # calculate the row and column indices for subplot
    row_ = m.floor(i/40*10)
    col_ = i%4
    
    # read the forward and backward data files
    file_cnt = i+1
    forward = np.loadtxt('file%d.dat.hist' %file_cnt, usecols = (0,1))
    backward = np.loadtxt('file%d.dat.rev.hist' %file_cnt, usecols = (0,1))
    
    # plot the forward and backward data on the subplot
    axs[row_,col_].plot(backward[:,0],backward[:,1], color='b',
                        label=r'$\lambda$=%.3f'%y[i])
    axs[row_,col_].plot(forward[:,0],forward[:,1], color='r',
                        label=r'$\lambda$=%.3f'%y[i+1])
    axs[row_,col_].plot([],[], color='k',
                        label=r'$D_{KL}$=%.1f'%kl[i]+r', H=%.1f'%hell[i])

    # set the y-axis ticks
    ymin,ymax = axs[row_,col_].get_ylim()
    axs[row_,col_].set_yticks(np.arange(0, ymax, 0.5),fontsize=14)
    # set the x-axis ticks
    xmin,xmax = axs[row_,col_].get_xlim()
    axs[row_,col_].set_xticks(np.arange(m.floor(xmin), xmax, 2),
                              fontsize=14)
    if row_==0 and col_==0:
        axs[0,0].set_xticks(np.arange(m.floor(xmin), xmax, 4))
     
    # set the minor axis ticks
    axs[row_,col_].xaxis.set_minor_locator(MultipleLocator(1))
    axs[row_,col_].yaxis.set_minor_locator(MultipleLocator(.25))

    # set the x and y limits of the subplot
    axs[row_,col_].set(xlim=(xmin, xmax), ylim=(0, ymax))
    # set the tick parameters
    axs[row_,col_].tick_params(direction='out', length=6, width=1.25)
    axs[row_,col_].tick_params(direction='out', which='minor',
                               length=3, width=1.25)
    axs[row_,col_].tick_params(axis='both', which='major', labelsize=16)

    l = axs[row_,col_].legend(handlelength=0, handletextpad=0,
                              labelcolor='linecolor',fontsize=16, 
                              loc='upper right')
    for item in l.legendHandles:
        item.set_visible(False)    

axs[9,3].tick_params(axis='both', which='major', labelsize=16)
fig.suptitle(r"$<D_{KL}>=$%2.1f, " %np.mean(kl)+r"<H>=%2.1f " %np.mean(hell), fontsize=36, y=.91)
plt.savefig(f"./figs/all.pdf", bbox_inches='tight')
