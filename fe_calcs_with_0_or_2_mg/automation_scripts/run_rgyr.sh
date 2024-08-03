#!/bin/bash

#####################################################################
## This script makes directoris and runs RMSD analysis.            ##
#####################################################################


## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that needs to be analyzed
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="9-5NaCl_bb_colvar"
win_list="1-40winCmplx_30winLig "
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD
## set common_files directory path
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"

## loop over the compounds, conditions and replicas
## and setup the directories and run rmsd.tcl


for val1 in $dir_list; do
   cd ${val1}
   for val2 in $cond_list; do
        cd ${val2}/
        for val4 in $win_list;do
            cd ${val4}
            for val3 in $rep_list; do
                ## creat the necessary directories
                mkdir -p ${val3}/3-analysis/rgyr
                cd ${val3}/3-analysis/rgyr
                ## copy the analysis script
                cp ${cmn_dir}/rgyr.tcl .
                ## run the analysis w/ VMD (VMD needs to be installed
                ## and its path added to $PATH)
                vmd -dispdev text -e rgyr.tcl
                cd ../../../
            done
            cd ../
        done
        cd ../
    done
    cd ..
done

