#!/bin/bash

#####################################################################
## This script neutralizes the ligOnly system. Since RNA-ligand    ##
## system is neutral, then when RNA is removed to make the ligOnly ##
## system, the overall charge of ligOnly is non-zero. After        ##
## neutralization, 'ligandOnly.xyz' and 'fep_ligandOnly.pdb' are   ##
## regenerated.                                                    ##
#####################################################################



## make sure ambertools environment is properly setup before running this script
## you can activate the ambertools even before running this script to make sure you 
## have the right env
conda activate ambertools

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
dir_list="6-xanthine 7-caffeine"
cond_list="2-150KCl"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD
## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"

## loop over the compounds, conditions and replicas
## and fix the reionize
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            cp ${WD}/tleap_ligOnly.in .
            # Remove previous tleap.out file
            rm -f tleap_ligOnly.out
            # GenerateAmber coordinate, topology and parameter files. 
            tleap -f tleap_ligOnly.in >> tleap_ligOnly.out 2>&1
            cd ../../../
        done
        cd ../../
    done
    cd ..
done


## make sure bfee environment is properly setup before running this script
conda activate bfee
cd $PWD
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/    
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            ## copy python file from common_files
            cp ${cmn_dir}/gen_xyz_ligOnly.py .
            ## generate the files
            python gen_xyz_ligOnly.py
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
