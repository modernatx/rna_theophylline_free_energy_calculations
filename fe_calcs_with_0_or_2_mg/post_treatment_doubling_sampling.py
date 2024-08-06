#####################################################################
## Script for post-processing the BFEE2 files. used instead of the 
## BFEE2 GUI.
#####################################################################

import BFEE2.postTreatment as postTreatment
from BFEE2.commonTools import commonSlots, fileParser, ploter
import numpy as np
import os
import sys
import glob

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
mainDir = '/home/arasouli/repos/alchemical/rna_small_molecule_FE'

## the compounds, conditions and replicas that need to be processsed
# cmpnd_list = [ '2-theophylline', '3-1_methylxanthine', '4-3_methylxanthine', '5-hypoxanthine', '6-xanthine', '7-caffeine' ]
cmpnd_list = [ '6-xanthine']
cond_list = ['3-55NaCl_Mg/2-80winCmplx']

## output file
with open('results/55_NaCl_2Mg_TP3_GAF_80_1ns_unres.txt', 'w') as f:
    sys.stdout = f
    header = ['cmpnd', 'rep', 'ΔG(site,couple)', 'error(site,couple)', 'ΔG(site,c+o+a+r)', 'error(site,c+o+a+r)', 'ΔG(bulk,decouple)', 'error(bulk,decouple)', 'ΔG(bulk,c)', 'error(bulk,c)', 'ΔG(bulk,o+a+r)', 'ΔG(total)', 'error(total)']
    print(*header, sep='\t') # write header to file

    for cmpnd in cmpnd_list:
        for cond in cond_list:
            dir_ = os.path.join(mainDir,cmpnd,cond)
            # get all the direcories in here
            directories = [d for d in os.listdir(dir_)]
            int_directories = []
            # keep directories that start with int
            for directory in directories:
                if directory[0].isdigit() and os.path.isdir(os.path.join(dir_, directory)):
                    int_directories.append(directory)
                    
            int_directories.sort()
            for rep in int_directories:
                # path to simulalatons, doubling the sampling
                dir_str = os.path.join(mainDir,cmpnd,cond,rep,'2-sim_run/BFEE')
                # path to base calculation to use for other steps 
                dir_str2 = os.path.join(mainDir,cmpnd,'3-55NaCl_Mg/1-40winCmplx_30winLig',rep,'2-sim_run/BFEE')
                filePathes = [os.path.join(dir_str,'001_MoleculeBound/output/fep_forward.fepout'),
                  os.path.join(dir_str,'001_MoleculeBound/output/fep_backward.fepout'),
                  os.path.join(dir_str2,'002_RestraintBound/002.2_ti_forward.log'),
                  os.path.join(dir_str2,'002_RestraintBound/002.1_ti_backward.log'),
                  os.path.join(dir_str2,'003_MoleculeUnbound/output/fep_forward.fepout'),
                  os.path.join(dir_str2,'003_MoleculeUnbound/output/fep_backward.fepout'),
                  os.path.join(dir_str2,'004_RestraintUnbound/004.2_ti_forward.log'),
                  os.path.join(dir_str2,'004_RestraintUnbound/004.1_ti_backward.log')]

                lis_str = read_colvar(os.path.join(dir_str,'001_MoleculeBound/colvars.in'))
                lis = [float(l) for l in lis_str]
                
                parameters = np.append(lis,[0.1, 0.1, 0.1, 0.1, 0.1, 10])
                pTreat = postTreatment.postTreatment(298.0,'namd')
                result, errors = pTreat.alchemicalBindingFreeEnergy(filePathes,parameters)
                cmpnd_name = cmpnd.strip().split('-')[1]
                cond_name = cond.strip().split('/')[0]
                rep_name = rep.strip().split('-')[1]
                data = [cmpnd_name, rep_name, result[0], errors[0], result[1], errors[1], result[2], errors[2], result[3], errors[3], result[4], result[5], errors[5]]
                print(*data, sep='\t') # write data to file
