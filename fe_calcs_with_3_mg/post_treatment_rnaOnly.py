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
                

## Path which contains all the simulations
# mainDir = '/PATH/TO/MAIN/DIR'
# mainDir = '/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE'
mainDir = '/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg'

## the compounds, conditions and replicas that need to be processsed
# cmpnd_list = [ '2-theophylline', '3-1_methylxanthine', '4-3_methylxanthine', '5-hypoxanthine', '6-xanthine', '7-caffeine' ]
cmpnd_list = [ '8-rna_RMSD_colvar_contr' ]
cond_list = ['1-55NaCl_3Mg/1-40win']
rep_list = [ '1-rep1', '2-rep2', '3-rep3', '4-rep4']

## output file
with open('results/BFEs/rna_only_3Mg_ref_wrap.txt', 'w') as f:
    sys.stdout = f
    for cmpnd in cmpnd_list:
        for cond in cond_list:
            for rep in rep_list:
                dir_str = os.path.join(mainDir,cmpnd,cond,rep,'2-sim_run/contribution_RMSD_ref_wrap')
                filePathes = [os.path.join(dir_str,'002.2_ti_forward.log'),
                  os.path.join(dir_str,'002.1_ti_backward.log'),]
                
                pTreat = postTreatment.postTreatment(298.0,'namd')
                freeEnergies = []
                for i in range(len(filePathes)):
                    freeEnergies.append(pTreat._alchemicalFepoutFile(filePathes[i], 'log'))
                
                print(freeEnergies)
                contributions = -(freeEnergies[0] + freeEnergies[1]) / 2
                errors = abs((freeEnergies[0] - freeEnergies[1]) / 1.414)
                
                # parameters = np.append(lis,[0.1, 0.1, 0.1, 0.1, 0.1, 10])
                # pTreat = postTreatment.postTreatment(298.0,'namd')
                # result, errors = pTreat.alchemicalBindingFreeEnergy(filePathes,parameters)
                # print(cmpnd.strip().split('-')[1],cond.strip().split('/')[0],rep.strip().split('-')[1])
                print(f'\
                Results:\n\
                ΔG(site,couple)   = {contributions:.1f} ± {errors:.1f} kcal/mol')
            
