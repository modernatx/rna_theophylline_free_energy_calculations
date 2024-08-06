#!/bin/bash

#####################################################################
## This script setups simulations to test effects of running the   ##
## forward transformation in parallel with the backward (both      ##
## starting from the "000_eq/output/eq.restart.*") as opposed to   ##
## first running backward and use the last frame of backward as    ##
## input to the forward. We only do this test for the system that  ##
## ligand is bound to the host. Test is done the step 1 and 2 of   ##
## BFEE protocol, namely the FEP and TI to calculate free energy   ##
## of binding with restraints and calculate the contribution of    ##
## the restraints on the previous calculation, respectively.       ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list)
dir_list="2-theophylline"
cond_list="4-55NaCl 5-55NaCl_bb"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD
## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"

## loop over the compounds, conditions and replicas
## and setup the directories and copy the necessary files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/    
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            mkdir -p test_bkw_frw_001_MoleculeBound/output
            ## copy input files from the deafult BFEE files
            cp 001_MoleculeBound/*conf 001_MoleculeBound/colvar* test_bkw_frw_001_MoleculeBound
            ## copy run script for step 1
	        cp ${cmn_dir}/run_1.sh .
            ## change the input of the conf files and set them to "000_eq/output/eq.restart.*"
            sed -i 's/bincoordinates    output\/fep_backward.coor/bincoordinates    ..\/000_eq\/output\/eq.coor/g' test_bkw_frw_001_MoleculeBound/001.2_fep_forward.conf
            sed -i 's/binvelocities    output\/fep_backward.vel/binvelocities    ..\/000_eq\/output\/eq.vel/g' test_bkw_frw_001_MoleculeBound/001.2_fep_forward.conf
            sed -i 's/ExtendedSystem    output\/fep_backward.xsc/ExtendedSystem    ..\/000_eq\/output\/eq.xsc/g' test_bkw_frw_001_MoleculeBound/001.2_fep_forward.conf
            
            ## make directories to setup the simulation for the step 2 of BFEE
	        mkdir -p test_bkw_frw_002_RestraintBound/output
            ## copy run script for step 2
            cp 002_RestraintBound/*conf 002_RestraintBound/colvar* test_bkw_frw_002_RestraintBound
            ## change the input of the conf files and set them to "000_eq/output/eq.restart.*"
            sed -i 's/bincoordinates    output\/ti_backward.coor/bincoordinates    ..\/000_eq\/output\/eq.coor/g' test_bkw_frw_002_RestraintBound/002.2_ti_forward.conf
            sed -i 's/binvelocities    output\/ti_backward.vel/binvelocities    ..\/000_eq\/output\/eq.vel/g' test_bkw_frw_002_RestraintBound/002.2_ti_forward.conf
            sed -i 's/ExtendedSystem    output\/ti_backward.xsc/ExtendedSystem    ..\/000_eq\/output\/eq.xsc/g' test_bkw_frw_002_RestraintBound/002.2_ti_forward.conf
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
