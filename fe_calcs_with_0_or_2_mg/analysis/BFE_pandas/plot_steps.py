import pandas as pd
import matplotlib.pyplot as plt
import numpy as np



def extract_data(dG_name, err_name, df):
    # extract ΔG(site,couple) values for each compound and each replica
    cmpnd_list = [ 'theophylline', '1_methylxanthine', '3_methylxanthine', 'hypoxanthine', 'xanthine', 'caffeine' ]
    rep_list = [ 'rep1', 'rep2', 'rep3']

    # define a dict with compund names as keys 
    data = {key:[] for key in cmpnd_list}
    for cmp in cmpnd_list:
        for rep in rep_list:
            # check if it is the contribution of restraints for ligand only system
            # and if so add the ΔG(bulk,c) + ΔG(bulk,o+a+r)
            if dG_name == 'ΔG(bulk,c)':
                data[cmp].append(df.loc[cmp,rep][dG_name]+df.loc[cmp,rep]['ΔG(bulk,o+a+r)'])
            else:
                data[cmp].append(df.loc[cmp,rep][dG_name])

    # define a dict with compund names as keys 
    data_err = {key:[] for key in cmpnd_list}
    for cmp in cmpnd_list:
        for rep in rep_list:
            data_err[cmp].append(df.loc[cmp,rep][err_name])

    return data, data_err


def plot_reps(data, data_err, fig_name, color, title_txt):
    if color=='b':
        colors = plt.cm.Blues(np.linspace(0.3, 1, 3))
    else:
        colors = plt.cm.Reds(np.linspace(0.3, 1, 3))

    fig, ax = plt.subplots()
    bar_width = 0.2
    bar_x = list(range(len(data)))

    for (i, (key, values)) in enumerate(data.items()):
        for j, value in enumerate(values):
            error = data_err[key][j]
            ax.bar(bar_x[i] + j * bar_width, value, bar_width, color=colors[j % 3], yerr=error, align='center', capsize=3)

    # find the minimum and maximum values in the data
    data_min = min([min(value) for value in data.values()])
    data_max = max([max(value) for value in data.values()])
    # automatically set the y-axis limits
    plt.ylim(ymin=data_min - 10, ymax=data_max + 10)
    if fig_name.startswith('s1'):
        ax.set_ylabel('ΔG(site,couple) kcal/mol', fontsize=14)
        plt.ylim(-310, -170)
    elif fig_name.startswith('s2'):
        plt.ylim(-15,0)
        ax.set_ylabel('ΔG(site,restraints) kcal/mol', fontsize=14)
    elif fig_name.startswith('s3'):
        plt.ylim(160,290)
        ax.set_ylabel('ΔG(bulk,couple) kcal/mol', fontsize=14)
    elif fig_name.startswith('s4'):
        plt.ylim(11,13)
        ax.set_ylabel('ΔG(bulk,restraints) kcal/mol', fontsize=14)
        ytick_ = [11, 12, 13]
        ax.set_yticks(ytick_)
    # set xticks to be in the center of three reps
    xt = [ x + .2 for x in list(range(len(data)))]
    ax.set_xticks(xt)
    
    ax.set_title(title_txt, fontsize=15)
    cmpnd_list = [ 'Theophylline', '1-Methylxanthine', '3-Methylxanthine', 'Hypoxanthine', 'Xanthine', 'Caffeine' ]

    ax.set_xticklabels(cmpnd_list, rotation=30, ha='center', va='top', fontsize=12)
    
    ax.legend(['rep 1', 'rep 2', 'rep 3'])
    ax.grid(True, axis='y', linestyle='--', alpha=0.6)

    plt.tight_layout()
    
    plt.savefig(f"./figs/%s.pdf" % fig_name, bbox_inches='tight')
    # plt.show()

# df = pd.read_csv("./transfer_BFE/pandas_55KCl_2Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55KCl_2Mg_40_30', 'r', '55 mM KCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55KCl_2Mg_40_30', 'r', '55 mM KCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55KCl_2Mg_40_30', 'b', '55 mM KCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55KCl_2Mg_40_30', 'b', '55 mM KCl & 2 Mg$^{2+}$')


# #### 55 NaCl 0Mg
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_0Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_0Mg_40_30', 'r', '55 mM NaCl & 0 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_0Mg_40_30', 'r', '55 mM NaCl & 0 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_0Mg_40_30', 'b', '55 mM NaCl & 0 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_0Mg_40_30', 'b', '55 mM NaCl & 0 Mg$^{2+}$')


# #### 55 NaCl 0Mg + colvar RMSD on BB
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_0Mg_colvarBB_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_0Mg_colvarBB_40_30', 'r', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone RMSD restraint')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_0Mg_colvarBB_40_30', 'r', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone RMSD restraint')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_0Mg_colvarBB_40_30', 'b', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone RMSD restraint')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_0Mg_colvarBB_40_30', 'b', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone RMSD restraint')

# #### 55 NaCl 0Mg + positional rest. on BB
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_0Mg_posBB_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_0Mg_posBB_40_30', 'r', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone positional restraint')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_0Mg_posBB_40_30', 'r', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone positional restraint')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_0Mg_posBB_40_30', 'b', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone positional restraint')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_0Mg_posBB_40_30', 'b', '55 mM NaCl & 0 Mg$^{2+}$\nw/ backbone positional restraint')

# #### 55 NaCl 2Mg 
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_2Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_2Mg_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_2Mg_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_2Mg_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_2Mg_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$')

# #### 55 NaCl 2Mg + colvar RMSD on BB
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_2Mg_colvarBB_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_2Mg_colvarBB_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone RMSD restraint')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_2Mg_colvarBB_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone RMSD restraint')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_2Mg_colvarBB_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone RMSD restraint')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_2Mg_colvarBB_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone RMSD restraint')

# #### 55 NaCl 2Mg + positional rest. on BB
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_2Mg_posBB_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_2Mg_posBB_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone positional restraint')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_2Mg_posBB_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone positional restraint')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_2Mg_posBB_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone positional restraint')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_2Mg_posBB_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$\nw/ backbone positional restraint')

# #### 55 NaCl 3Mg 
# df = pd.read_csv("./transfer_BFE/pandas_55NaCl_3Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_3Mg_40_30', 'r', '55 mM NaCl & 3 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_3Mg_40_30', 'r', '55 mM NaCl & 3 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_3Mg_40_30', 'b', '55 mM NaCl & 3 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_3Mg_40_30', 'b', '55 mM NaCl & 3 Mg$^{2+}$')

# #### 150 KCl 2Mg 
# df = pd.read_csv("./transfer_BFE/pandas_150KCl_2Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_150KCl_2Mg_40_30', 'r', '150 mM KCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_150KCl_2Mg_40_30', 'r', '150 mM KCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_150KCl_2Mg_40_30', 'b', '150 mM KCl & 2 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_150KCl_2Mg_40_30', 'b', '150 mM KCl & 2 Mg$^{2+}$')

# #### Neutral 3Mg 
# df = pd.read_csv("./transfer_BFE/pandas_Neut_3Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_Neut_3Mg_40_30', 'r', 'Neutralized & 3 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_Neut_3Mg_40_30', 'r', 'Neutralized & 3 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_Neut_3Mg_40_30', 'b', 'Neutralized & 3 Mg$^{2+}$')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_Neut_3Mg_40_30', 'b', 'Neutralized & 3 Mg$^{2+}$')

# #### 55 NaCl 2Mg + OPC water
# df = pd.read_csv("./transfer_BFE/pandas_OPC_55NaCl_2Mg_40_30.txt", sep='\t', header=0)
# df.set_index(['cmpnd', 'rep'], inplace=True)

# data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
# plot_reps(data, data_err, 's1_55NaCl_2Mg_OPC_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$\n w/ OPC water')

# data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
# plot_reps(data, data_err, 's2_55NaCl_2Mg_OPC_40_30', 'r', '55 mM NaCl & 2 Mg$^{2+}$\n w/ OPC water')

# data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
# plot_reps(data, data_err, 's3_55NaCl_2Mg_OPC_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$\n w/ OPC water')

# data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
# plot_reps(data, data_err, 's4_55NaCl_2Mg_OPC_40_30', 'b', '55 mM NaCl & 2 Mg$^{2+}$\n w/ OPC water')

#### 55 NaCl 3Mg + bb colvar rest
df = pd.read_csv("./transfer_BFE/pandas_55NaCl_3Mg_bb_colvar_40_30.txt", sep='\t', header=0)
df.set_index(['cmpnd', 'rep'], inplace=True)

data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
plot_reps(data, data_err, 's1_55NaCl_3Mg_colvarBB_40_30', 'r', '55 mM NaCl & 3 Mg$^{2+}$\nw/ backbone RMSD restraint')

data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
plot_reps(data, data_err, 's2_55NaCl_3Mg_colvarBB_40_30', 'r', '55 mM NaCl & 3 Mg$^{2+}$\nw/ backbone RMSD restraint')

data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
plot_reps(data, data_err, 's3_55NaCl_3Mg_colvarBB_40_30', 'b', '55 mM NaCl & 3 Mg$^{2+}$\nw/ backbone RMSD restraint')

data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
plot_reps(data, data_err, 's4_55NaCl_3Mg_colvarBB_40_30', 'b', '55 mM NaCl & 3 Mg$^{2+}$\nw/ backbone RMSD restraint')


#### 55 KCl 3Mg 
df = pd.read_csv("./transfer_BFE/pandas_55KCl_3Mg_40_30.txt", sep='\t', header=0)
df.set_index(['cmpnd', 'rep'], inplace=True)

data, data_err = extract_data('ΔG(site,couple)', 'error(site,couple)',df)
plot_reps(data, data_err, 's1_55KCl_3Mg_40_30', 'r', '55 mM KCl & 3 Mg$^{2+}$')

data, data_err = extract_data('ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)',df)
plot_reps(data, data_err, 's2_55KCl_3Mg_40_30', 'r', '55 mM KCl & 3 Mg$^{2+}$')

data, data_err = extract_data('ΔG(bulk,decouple)', 'error(bulk,decouple)',df)
plot_reps(data, data_err, 's3_55KCl_3Mg_40_30', 'b', '55 mM KCl & 3 Mg$^{2+}$')

data, data_err = extract_data('ΔG(bulk,c)', 'error(bulk,c)',df)
plot_reps(data, data_err, 's4_55KCl_3Mg_40_30', 'b', '55 mM KCl & 3 Mg$^{2+}$')