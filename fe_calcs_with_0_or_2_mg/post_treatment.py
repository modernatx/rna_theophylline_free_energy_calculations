#####################################################################
## Script for post-processing the BFEE2 files. used instead of the 
## BFEE2 GUI.
#####################################################################

import BFEE2.postTreatment as postTreatment
from BFEE2.commonTools import commonSlots, fileParser, ploter
import numpy as np
import os
import sys

def read_colvar(filePath):
    with open(filePath, 'r', encoding='utf-8') as colvarFile:
        lines = colvarFile.readlines()
        for idx, line in enumerate(lines):
            if ('colvars         eulerTheta' in line):
                eulerTheta_idx = idx +2
            if ('colvars         polarTheta' in line):
                polarTheta_idx = idx +2
            if ('colvars         r' in line):
                r_idx = idx +2
    eulerTheta = lines[eulerTheta_idx].strip().split()[1]
    polarTheta = lines[polarTheta_idx].strip().split()[1]
    r = lines[r_idx].strip().split()[1]
    
    return np.array([eulerTheta, polarTheta,r])
                
## Path in which all the contains all the simulations
# mainDir = '/PATH/TO/MAIN/DIR'
# mainDir = '/home/arasouli/repos/alchemical/rna_small_molecule_FE'
mainDir = '/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg'


## the compounds, conditions and replicas that need to be processsed
# cmpnd_list = [ '2-theophylline', '3-1_methylxanthine', '4-3_methylxanthine', '5-hypoxanthine', '6-xanthine', '7-caffeine' ]
cmpnd_list = [ '3-1_methylxanthine' ]
cond_list = ['3-55NaCl_Mg/1-40winCmplx_30winLig']
# rep_list = [ '1-rep1', '2-rep2', '3-rep3']
rep_list = [ '3-rep3_2']

## output file
with open('results/BFEs/3-3-rep3_2.txt', 'w') as f:
    sys.stdout = f
    for cmpnd in cmpnd_list:
        for cond in cond_list:
            for rep in rep_list:
                dir_str = os.path.join(mainDir,cmpnd,cond,rep,'2-sim_run/BFEE')
                filePathes = [os.path.join(dir_str,'001_MoleculeBound/output/fep_forward.fepout'),
                  os.path.join(dir_str,'001_MoleculeBound/output/fep_backward.fepout'),
                  os.path.join(dir_str,'002_RestraintBound/002.2_ti_forward.log'),
                  os.path.join(dir_str,'002_RestraintBound/002.1_ti_backward.log'),
                  os.path.join(dir_str,'003_MoleculeUnbound/output/fep_forward.fepout'),
                  os.path.join(dir_str,'003_MoleculeUnbound/output/fep_backward.fepout'),
                  os.path.join(dir_str,'004_RestraintUnbound/004.2_ti_forward.log'),
                  os.path.join(dir_str,'004_RestraintUnbound/004.1_ti_backward.log')]

                lis_str = read_colvar(os.path.join(dir_str,'001_MoleculeBound/colvars.in'))
                lis = [float(l) for l in lis_str]
                
                parameters = np.append(lis,[0.1, 0.1, 0.1, 0.1, 0.1, 10])
                pTreat = postTreatment.postTreatment(298.0,'namd')
                result, errors = pTreat.alchemicalBindingFreeEnergy(filePathes,parameters)
                print(cmpnd.strip().split('-')[1],cond.strip().split('/')[0],rep.strip().split('-')[1])
                print(f'\
                Results:\n\
                ΔG(site,couple)   = {result[0]:.1f} ± {errors[0]:.1f} kcal/mol\n\
                ΔG(site,c+o+a+r)  = {result[1]:.1f} ± {errors[1]:.1f} kcal/mol\n\
                ΔG(bulk,decouple) = {result[2]:.1f} ± {errors[2]:.1f} kcal/mol\n\
                ΔG(bulk,c)        = {result[3]:.1f} ± {errors[3]:.1f} kcal/mol\n\
                ΔG(bulk,o+a+r)    = {result[4]:.1f} kcal/mol\n\
                \n\
                Standard Binding Free Energy:\n\
                ΔG(total)         = {result[5]:.1f} ± {errors[5]:.1f} kcal/mol\n')
            
