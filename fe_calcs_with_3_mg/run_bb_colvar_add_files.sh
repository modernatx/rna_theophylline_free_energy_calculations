#!/bin/bash

#####################################################################
## This script generates complex.xyz file (as a reference in the colvar)
## and also an index file to specify atoms invloved in the RMSD colvar.
## It also adds the keywords to NAMD conf files for colvars.
## Run this after "run_bb_colvar.sh" creates the directories.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
# dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
dir_list="2-theophylline"
cond_list="4-55NaCl_3Mg_bb_colvar"
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
WD=$PWD



## loop over the compounds, conditions and replicas
## and genrate xyz and ndx files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
            cp -r ${cmn_dir}/run_1_bb_colvar_equ.sh  ./2-sim_run/run_1.sh 
            
            cd 2-sim_run/restraints
            cp ${cmn_dir}/gen_xyz_bb_colvar.py .
            rm -f complex.xyz
            python gen_xyz_bb_colvar.py
            
            cp ${cmn_dir}/gen_index_group.tcl .
            rm -f bb.ndx
            vmd -dispdev text -e gen_index_group.tcl
            cd ../../
            
            cp ${cmn_dir}/bb_colvars.in ./2-sim_run/equ_1

            
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
