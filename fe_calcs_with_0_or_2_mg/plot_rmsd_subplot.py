import os
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import numpy as np

mainDir = '/home/arasouli/repos/alchemical/rna_small_molecule_FE'

cmpnd_list = [ '2-theophylline', '3-1_methylxanthine', '4-3_methylxanthine', '5-hypoxanthine', '6-xanthine', '7-caffeine' ]
cond_list = ['3-55NaCl_Mg/1-40winCmplx_30winLig']
rep_list = ['1-rep1', '2-rep2', '3-rep3']

dir_str = []
for cmpnd in cmpnd_list:
    for cond in cond_list:
        for rep in rep_list:
            dir_str.append(os.path.join(mainDir,cmpnd,cond,rep,'3-analysis/plot'))



# Create the data to plot
x = np.linspace(0, 10, 100)
y = np.sin(x)

# Set up the subplots
fig, axes = plt.subplots(nrows=6, ncols=3, figsize=(12, 18))


# Loop through each row and column
for i in range(6):
    for j in range(3):
        dir_str_ = dir_str[i+j]
        # Set the tick labels and axis labels for the first column and last row
        if j == 0:
            axes[i, j].set_ylabel('y-axis label')
            axes[i, j].set_yticklabels([str(i) for i in range(10)])
        else:
            axes[i, j].set_yticklabels([])
            
        if i == 5:
            axes[i, j].set_xlabel('x-axis label')
            axes[i, j].set_xticklabels([str(i) for i in range(10)])
        elif j != 0:
            axes[i, j].set_xticklabels([])
        
        # Plot the data
        axes[i, j].plot(x, y)
        
# Set the overall title
# fig.suptitle('Subplots with 3 columns and 6 rows')

# Show the plot
plt.show()
