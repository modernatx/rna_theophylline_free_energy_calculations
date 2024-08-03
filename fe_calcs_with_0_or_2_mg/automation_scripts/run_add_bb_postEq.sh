#!/bin/bash

#####################################################################
## This script generates the directories and copies the input      ##
## files from the "3-55NaCl_Mg" condition and then modifies the    ##
## config files to adds the necessary lines                        ##
## (only in step 1 and 2 in which we have RNA) to enforce          ## 
## positional restraints on the backbone of the RNA                ##
## during the ligand-bound transformations. The reference for the  ##
## backbone is its position in the last frame of 000_eq (10 ns of  ##
## unrestrained simulation).                                       ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that needs to be first created and 
## then modified
dir_list="2-theophylline_with_Mg 6-xanthine 7-caffeine"
cond_list="7-55NaCl_Mg_postEq_bb"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD

## mking the necessary directories that should match the "dir_list",
## "cond_list", and "rep_list"
mkdir -p {2-theophylline_with_Mg,6-xanthine,7-caffeine}/7-55NaCl_Mg_postEq_bb/1-40winCmplx_30winLig/{1-rep1,2-rep2,3-rep3}


## loop over the compounds, conditions and replicas
## and setup the directories and copy the necessary files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        ## copy files and dir structure from 3-55NaCl_Mg
        rsync -r --include={"*.conf","*.pdb","*.psf","*.tcl","*.sh","*.parm7","*.inpcrd","*.ndx","*.xyz","*.in","*/"}  --exclude="*" ../../3-55NaCl_Mg/1-40winCmplx_30winLig/ .
        rsync -r --include={"**/000_eq/output/*.coor","**/000_eq/output/*.vel","**/000_eq/output/*.xsc","*/"} --exclude="*" ../../3-55NaCl_Mg/1-40winCmplx_30winLig/ .
        ## cp restraints.tcl file from 6-55NaCl_Mg_bb 
        cp ../../6-55NaCl_Mg_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints/restraints.tcl 1-rep1/2-sim_run/restraints
        cp ../../6-55NaCl_Mg_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints/restraints.tcl 2-rep2/2-sim_run/restraints
        cp ../../6-55NaCl_Mg_bb/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints/restraints.tcl 3-rep3/2-sim_run/restraints
        ## change restrints.tcl to set last freme of 000_eq to be reference
        sed -i 's/mol new ..\/..\/1-sys_prep\/box.pdb/mol new ..\/..\/1-sys_prep\/box.psf/' */2-sim_run/restraints/restraints.tcl
        sed -i '12imol addfile ../BFEE/000_eq/output/eq.coor' */2-sim_run/restraints/restraints.tcl
        
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            ## add lines for bb restraints    
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
                
            cd ../restraints
            ## run restraints.tcl to generate the reference file
            ## VMD should be installed and its path added to $PATH
            vmd -dispdev text -e restraints.tcl
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
