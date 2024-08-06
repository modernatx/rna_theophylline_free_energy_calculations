#!/bin/bash

#####################################################################
## Set up directories and files for backbone restrained simulations
## from the "4-55NaCl" system.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine"
cond_list="5-55NaCl_bb"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD

mkdir -p {3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine}/5-55NaCl_bb/1-40winCmplx_30winLig/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
            cp -r ../../../4-55NaCl/1-40winCmplx_30winLig/${val3}/0-starting_PDB/ .
            cp -r ../../../4-55NaCl/1-40winCmplx_30winLig/${val3}/1-sys_prep/ .
            mkdir -p ./2-sim_run/{equ_0,equ_1,restraints}
            
            #cp /home/arasouli/repos/alchemical/rna_small_molecule_FE/2-theophylline/5-55NaCl_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_0/*conf ./2-sim_run/equ_0
            #cp /home/arasouli/repos/alchemical/rna_small_molecule_FE/2-theophylline/5-55NaCl_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_1/*conf ./2-sim_run/equ_1
            #cp /home/arasouli/repos/alchemical/rna_small_molecule_FE/2-theophylline/5-55NaCl_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints/*tcl ./2-sim_run/restraints

            cp /home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/2-theophylline/5-55NaCl_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_0/*conf ./2-sim_run/equ_0
            cp /home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/2-theophylline/5-55NaCl_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_1/*conf ./2-sim_run/equ_1
            cp /home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/2-theophylline/5-55NaCl_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints/*tcl ./2-sim_run/restraints
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
