#####################################################################
## Script for post-processing the BFEE2 files. used instead of the 
## BFEE2 GUI.
#####################################################################

import BFEE2.postTreatment as postTreatment
from BFEE2.commonTools import commonSlots, fileParser, ploter
import numpy as np
import os
import sys                 

                
## Path in which all the contains all the simulations
# mainDir = '/PATH/TO/MAIN/DIR'
# mainDir = '/home/arasouli/repos/alchemical/rna_small_molecule_FE'
# mainDir = '/home/arasouli/shared/computational-sciences/misik/alchemical_fe_theophylline'
mainDir = '/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg'

## the compounds, conditions and replicas that need to be processed
# cmpnd_list = [ '2-theophylline', '3-1_methylxanthine', '4-3_methylxanthine', '5-hypoxanthine', '6-xanthine', '7-caffeine' ]
cmpnd_list = [ '8-rna_RMSD_colvar_contr' ]
cond_list = ['2-55NaCl_0Mg/1-40win'] #cond_list = ['1-55NaCl_2Mg/1-40win']
rep_list = [ '1-rep1', '2-rep2', '3-rep3', '4-rep4']

## output file
with open('results/BFEs/rna_only_0Mg_ref_wrap_2.txt', 'w') as f:
    sys.stdout = f
    for cmpnd in cmpnd_list:
        for cond in cond_list:
            for rep in rep_list:
                dir_str = os.path.join(mainDir,cmpnd,cond,rep,'2-sim_run/contribution_RMSD_ref_wrap')
                filePathes = [os.path.join(dir_str,'002.2_ti_forward.log'),
                  os.path.join(dir_str,'002.1_ti_backward.log'),]
                
                pTreat = postTreatment.postTreatment(298.0,'namd')
                # reading the free energies from the bkwd and fwd TIs
                freeEnergies = []
                for i in range(len(filePathes)):
                    freeEnergies.append(pTreat._alchemicalFepoutFile(filePathes[i], 'log'))
                
                print(freeEnergies)
                contributions = -(freeEnergies[0] + freeEnergies[1]) / 2
                errors = abs((freeEnergies[0] - freeEnergies[1]) / 1.414)
                
                print(f'\
                Results:\n\
                ΔG(site,couple)   = {contributions:.1f} ± {errors:.1f} kcal/mol')
            
