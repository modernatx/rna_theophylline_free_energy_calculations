#!/bin/bash

#####################################################################
## This script centers the RNA and the small molecule to be in the ##
## and saves a pdb and psf in "ini" directory.                     ##
## WARNING: make sure to open                                      ##
## the saved files and check if the ligand has been properly       ##
## wrapped. If a ligand is stretched across the periodic boundry, the ##
## calculations will be faulty.                                    ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list)
dir_list="8-rna_RMSD_colvar_contr"
# dir_list="7-caffeine"
cond_list="1-55NaCl_3Mg"
rep_list="1-rep1 2-rep2 3-rep3"

## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

## loop over the compounds, conditions and replicas and wrap
## vmd needs to be installed and its path needs to be added to $PATH
for val1 in $dir_list; do
    for val2 in $cond_list; do
        for val3 in $rep_list; do
            cd ${val1}/${val2}/1-40win/${val3}/2-sim_run
            ## copy the wrap script from the common_files and execute it with VMD (VMD 
            ## should be installed and its path added to $PATH)
            
            cp ${cmn_dir}/wrap_rna_only.tcl .
            vmd -dispdev text -e wrap_rna_only.tcl
            cd ../../../../..
        done
    done
done
