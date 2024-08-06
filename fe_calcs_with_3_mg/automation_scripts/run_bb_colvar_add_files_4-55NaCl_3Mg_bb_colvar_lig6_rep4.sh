#!/bin/bash

#####################################################################
## This script generates complex.xyz file (as a reference in the colvar)
## and also an index file to specify atoms involved in the RMSD colvar.
## It also adds the keywords to NAMD conf files for colvars.
## Run this after "run_bb_colvar.sh" creates the directories.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="6-xanthine"
cond_list="4-55NaCl_3Mg_bb_colvar"
rep_list="4-rep4"

#cmn_dir="/home/misik/repos/3_mg_rna_small_molecule_fe/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

WD=$PWD


## loop over the compounds, conditions and replicas
## and genrate xyz and ndx files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
            cp -r ${cmn_dir}/run_1_bb_colvar_equ_MI.sh  ./2-sim_run/run_1.sh 
            
            cd 2-sim_run/restraints
            cp ${cmn_dir}/gen_xyz_bb_colvar.py .
            rm -f complex.xyz
            python gen_xyz_bb_colvar.py
            
            # WARNING: Check the path in gen_index_group_MI.tcl before running.
            cp ${cmn_dir}/gen_index_group_MI.tcl .
            rm -f bb.ndx
            vmd -dispdev text -e gen_index_group_MI.tcl
            cd ../../
            
            cp ${cmn_dir}/bb_colvars.in ./2-sim_run/equ_1
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
