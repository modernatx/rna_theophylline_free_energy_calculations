import os
import numpy as np
# set the list of compounds, conditions, and replicas that need to be created
dir_list = ["2-theophylline", "3-1_methylxanthine", "4-3_methylxanthine", "5-hypoxanthine", "6-xanthine", "7-caffeine"]
cond_list = ["3-55NaCl_Mg"]
rep_list = ["1-rep1", "2-rep2", "3-rep3"]
common_dir = "/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"

# loop over the compounds, conditions, and replicas
for dir_name in dir_list:
    os.chdir(os.path.join(os.getcwd(), dir_name))
    
    for cond_name in cond_list:
        os.chdir(os.path.join(cond_name, "1-40winCmplx_30winLig"))
        
        for rep_name in rep_list:
            os.chdir(rep_name)
            
            # extract the cv_list from colvars.in file
            with open(os.path.join("2-sim_run", "BFEE", "001_MoleculeBound", "colvars.in"), "r") as f:
                cv_list = np.array([float(line.split()[1]) for line in f if line.startswith("    Centers")])
            
            print(cv_list)
            
            os.chdir("..")
        os.chdir("../..")
    os.chdir("..")
