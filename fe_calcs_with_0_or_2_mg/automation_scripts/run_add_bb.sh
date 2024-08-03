#!/bin/bash

#####################################################################
## This script adds the necessary lines to the config files of     ##
## BFEE (only in step 1 and 2 in which we have RNA) to put         ## 
## positional restraints on the backbone of the RNA                ##
## during the ligand-bound transformations. The reference for the  ##
## backbone is its position in the pdb.                            ##
## This script assumes user has alredy used BFEE2GUI.py to         ##
## generate the directories and input files and it only modifies   ##
## the config files to add the bb restriants.                      ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be modified
dir_list="3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine"
cond_list="5-55NaCl_bb"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD

## loop over the compounds, conditions and replicas
## and add the lines to config files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            ## add lines for bb restraints
            sed -i '53iconstraints on' 000_eq/000.1_eq.conf
            sed -i '54iconsexp     2' 000_eq/000.1_eq.conf
            sed -i '55iconsref     ../../restraints/bb_restraints.pdb' 000_eq/000.1_eq.conf
            sed -i '56iconskfile   ../../restraints/bb_restraints.pdb' 000_eq/000.1_eq.conf
            sed -i '57iconskcol    B' 000_eq/000.1_eq.conf
            sed -i '58iconstraintScaling    2' 000_eq/000.1_eq.conf
            
            
            sed -i '51iconstraints on' 001_MoleculeBound/*.conf
            sed -i '52iconsexp     2' 001_MoleculeBound/*.conf
            sed -i '53iconsref     ../../restraints/bb_restraints.pdb' 001_MoleculeBound/*.conf
            sed -i '54iconskfile   ../../restraints/bb_restraints.pdb' 001_MoleculeBound/*.conf
            sed -i '55iconskcol    B' 001_MoleculeBound/*.conf
            sed -i '56iconstraintScaling    2' 001_MoleculeBound/*.conf
            
            sed -i '51iconstraints on' 002_RestraintBound/*.conf
            sed -i '52iconsexp     2' 002_RestraintBound/*.conf
            sed -i '53iconsref     ../../restraints/bb_restraints.pdb' 002_RestraintBound/*.conf
            sed -i '54iconskfile   ../../restraints/bb_restraints.pdb' 002_RestraintBound/*.conf
            sed -i '55iconskcol    B' 002_RestraintBound/*.conf
            sed -i '56iconstraintScaling    2' 002_RestraintBound/*.conf            
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
