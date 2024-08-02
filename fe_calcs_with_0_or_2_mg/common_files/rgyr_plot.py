import numpy as np
import math  as m
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib.patches import Rectangle
import seaborn as sns


x1 = np.loadtxt('../rgyr/2-rna_bb_rgyr.dat')
x2 = np.loadtxt('../rgyr/3-rna_bb_rgyr.dat')
x  = np.concatenate((x1,x2), axis=0)
t1 = np.arange(0,len(x1),1)
t2 = np.arange(0,len(x2),1)




# Create a figure with two subplots using gridspec
fig = plt.figure(figsize=(12, 6))
gs = fig.add_gridspec(1, 2, width_ratios=[2, 1])

# Plot the time series on the left
ax1 = fig.add_subplot(gs[0])
ax1.plot(x1, color='dodgerblue', label='Time Series')
ax1.set_title('Time Series')
ax1.set_xlim(0, len(x1))  # Set x-axis limits
ax1.tick_params(axis='both', which='both', labelsize=13)
ax1.legend()

# Plot the histogram on the right using the y-axis of the time series
ax2 = fig.add_subplot(gs[1])
counts, bins, _ = ax2.hist(x1, bins=30, color='skyblue', orientation='horizontal', density=True)
ax2.set_ylim(ax1.get_ylim())
ax2.set_title('Histogram')

# Compute mean and std
mean = np.mean(x1)
std = np.std(x1)

# Plot mean line
ax2.axhline(mean, color='red', linestyle='-', linewidth=2, label='Mean')

# Plot mean ± std box
ax2.axhspan(mean - std, mean + std, facecolor='lightgreen', alpha=0.3, label='Mean ± Std')

# Add text for mean and std values
ax2.text(0.05, mean+.1, f'Mean: {mean:.1f}', color='red', ha='left', va='center')
ax2.text(0.05, mean - std, f'Std: {std:.1f}', color='darkgreen', ha='left', va='center')

# Remove y-axis tick labels from the histogram subplot
ax2.set_yticklabels([])
ax2.tick_params(axis='both', which='both', labelsize=13)

# Set labels and adjust layout
# fig.suptitle('Time Series and Histogram')
plt.tight_layout()

# Show the plot
plt.show()









C = 0.5
fig, ax = plt.subplots()
plt.plot(t1 * C, x1[:,1], linewidth = 1, color = '#1f77b4', label = 'RNA backbone')
plt.plot(t1 * C, x2[:,1], linewidth = 1, color = '#d62728', label = 'ligand')
# plt.plot(t1 * C, x3[:,1], linewidth = 1, color = '#ff7f0e', label = 'Mg 1')
# plt.plot(t1 * C, x4[:,1], linewidth = 1, color = '#fdbf6f', label = 'Mg 2')

# ax.add_patch(Rectangle((0,0),214*C,30, facecolor = 'bisque', alpha = 0.3))
# ax.add_patch(Rectangle((214*C,0),20*C,30, facecolor = 'bisque', alpha = 0.3))
# ax.add_patch(Rectangle(((214+20)*C,0),160*C,30, facecolor = 'lavender', alpha = 0.3))
# ax.add_patch(Rectangle(((214+20+160)*C,0),164*C,30, facecolor = 'lightpink', alpha = 0.3))

ax.add_patch(Rectangle((0,0),214*C,30, facecolor = '#f9f9f9', alpha = 0.3))
ax.add_patch(Rectangle((214*C,0),20*C,30, facecolor = '#d9d9d9', alpha = 0.3))
ax.add_patch(Rectangle(((214+20)*C,0),160*C,30, facecolor = '#a6a6a6', alpha = 0.3))
ax.add_patch(Rectangle(((214+20+160)*C,0),164*C,30, facecolor = '#757575', alpha = 0.3))

# vertical lines for rhe bakw and frwd distinction
plt.vlines(314*C, -1, 10,colors='k', linestyles='dashed', label='', alpha=.1, linewidth=1)
plt.vlines(476*C, -1, 10,colors='k', linestyles='dashed', label='', alpha=.1, linewidth=1)

plt.grid(which='major', axis='y', alpha=.2)
plt.ylabel(r'RMSD ($\AA$)', fontsize = 15)
plt.xlabel('Time (ns)', fontsize = 15)
plt.xticks(fontsize = 16)
plt.yticks(fontsize = 16)
plt.ylim((0, 5))   # set the xlim to left, right
plt.xlim((0, (214+20+160+164)*C))   # set the xlim to left, right
# 	plt.xticks(np.arange(80, 1080.1, 200),['$0$','$200$','$400$','$600$','$800$','$1000$'])
plt.yticks(np.arange(0, 5.1, 1))
# 	#ax.set_xticklabels(['0','200','400','600','800','1000'])
# 	if m == 3:
# plt.legend(fontsize = 10, ncol = 1)

plt.savefig("rmsd_bb.pdf", bbox_inches='tight')

plt.close() 
