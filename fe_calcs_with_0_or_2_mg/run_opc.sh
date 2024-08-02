#!/bin/bash

#####################################################################
## Sets up direcotires and files for OPC simulation from the TIP3P
## system "3-55NaCl_Mg"
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="3-55NaCl_Mg"
# 6-opc_40winCmplx_30winLig
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files/opc_files"
WD=$PWD

mkdir -p {2-theophylline,3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine,6-xanthine,7-caffeine}/3-55NaCl_Mg/6-opc_40winCmplx_30winLig/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/6-opc_40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
            cp -r ../../../3-55NaCl_Mg/1-40winCmplx_30winLig/${val3}/0-starting_PDB/ .
            cp -r ../../../3-55NaCl_Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/ .
            cp ${cmn_dir}/tleap.in ./1-sys_prep
            cd ./1-sys_prep
            rm 2-run_system_setup.log
            source 2-run_system_setup.sh > 2-run_system_setup.log
            cd ../
            mkdir -p ./2-sim_run/
            
            cd ./2-sim_run
            cp -r ${cmn_dir}/equ_0 .
            cp -r ${cmn_dir}/equ_1 .
            cp -r ${cmn_dir}/equ_2 .
            cp -r ${cmn_dir}/restraints .
            cd ./restraints
            vmd -dispdev text -e restraints.tcl
            
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
