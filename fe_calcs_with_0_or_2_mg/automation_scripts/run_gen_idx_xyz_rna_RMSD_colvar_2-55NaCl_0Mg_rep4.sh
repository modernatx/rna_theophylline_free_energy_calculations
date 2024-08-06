#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list1=" 8-rna_RMSD_colvar_contr "
cond_list=" 2-55NaCl_0Mg/1-40win/ "
rep_list="4-rep4"
#cmn_dir="/home/misik/repos/alchemical_fe_theophylline/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"
WD=$PWD


# loop over all the compounds except tehophylline, conditions and replicas
# and copy files over
for val1 in $dir_list1; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}
        for val3 in $rep_list; do
            cd ${val3}/
            echo ${val1},${val2}${val3}
            
            # Create colvar_index.ndx
            cd 2-sim_run/contribution_RMSD_ref_wrap/
            vmd -dispdev text -e gen_index_group_MI.tcl > gen_index_group_MI.log

            # Create complex.xyz
            conda activate bfee
            python gen_xyz_bb_colvar.py > gen_xyz_bb_colvar.log
            conda deactivate

            cd ../../../
        done
        cd ../../
    done
    cd ..
done


