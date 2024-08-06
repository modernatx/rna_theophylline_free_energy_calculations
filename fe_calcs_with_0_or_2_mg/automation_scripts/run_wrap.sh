#!/bin/bash

#####################################################################
## This script centers the RNA and the small molecule to be in the ##
## and saves a pdb and psf in "ini" directory.                     ##
## WARNING: make sure to open                                      ##
## the saved files and check if the ligand has been properly       ##
## wrapped. If ligand is stretched across the periodic boundary, the ##
## calculations will be faulty.                                    ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list)
# dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
dir_list="5-hypoxanthine"
cond_list="9-5NaCl_bb_colvar"
# rep_list="1-rep1 2-rep2 3-rep3"
rep_list="1-rep1 3-rep3"
## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"

## loop over the compounds, conditions and replicas and wrap
## vmd needs to be installed and its path needs to be added to $PATH
for val1 in $dir_list; do
    for val2 in $cond_list; do
        for val3 in $rep_list; do
            cd ${val1}/${val2}/1-40winCmplx_30winLig/${val3}/2-sim_run
            ## copy the wrap script from the common_files and execute it with VMD (VMD 
            ## should be installed and its path added to $PATH)
            # if [ ${val1} == "2-theophylline" ] && [ ${val2} == "9-5NaCl_bb_colvar" ] && [ ${val3} == "3-rep3" ]; then
            #     cp ${cmn_dir}/wrap_2_9_rep3.tcl ./wrap.tcl
            # elif [ ${val1} == "3-1_methylxanthine" ] && [ ${val2} == "8-5NaCl_Mg_bb_colvar" ] && [ ${val3} == "2-rep2" ]; then
            #     cp ${cmn_dir}/wrap_3_8_rep2.tcl ./wrap.tcl
            # else
                cp ${cmn_dir}/wrap.tcl .
            # fi
            vmd -dispdev text -e wrap.tcl
            cd ../../../../..
        done
    done
done
