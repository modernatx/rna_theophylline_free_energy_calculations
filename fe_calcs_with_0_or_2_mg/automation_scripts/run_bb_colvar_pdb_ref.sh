#!/bin/bash

#####################################################################
## This script generates changes the reference for the backbone
## colvar RMSD in the BFEE steps to be the NMR structure (from initial 
## pdb by setting reference xyz file from the restraints directory, that
## we have for the initial 100 ns equilibration (before feeding it into BFEE)
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="8-5NaCl_Mg_bb_colvar 9-5NaCl_bb_colvar"
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
WD=$PWD



## loop over the compounds, conditions and replicas
## and genrate xyz and ndx files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/
        mkdir -p 2-40winCmplx_30winLig_pdb_ref/
        cd 2-40winCmplx_30winLig_pdb_ref
        for val3 in $rep_list; do
            mkdir -p ${val3}/2-sim_run/BFEE/{000_eq,001_MoleculeBound,002_RestraintBound}/output
            cd ${val3}/2-sim_run           
            cp -r ../../../1-40winCmplx_30winLig/${val3}/2-sim_run/restraints .
            cd BFEE
            cp ../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/complex.* .
            cp ../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/fep* .
            
            cd 000_eq
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/000_eq/000.1_eq.conf .
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/000_eq/*py .
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/000_eq/colvars.in .
            sed -i '/indexGroup  bb/{ n; n; s/refpositionsfile  ..\/complex.xyz/refpositionsfile  ..\/..\/restraints\/complex.xyz/g }' colvars.in
            
            cd ../001_MoleculeBound
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/001_MoleculeBound/*conf .
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/001_MoleculeBound/colvars.in .
            sed -i '/indexGroup  bb/{ n; n; s/refpositionsfile  ..\/complex.xyz/refpositionsfile  ..\/..\/restraints\/complex.xyz/g }' colvars.in
            
            cd ../002_RestraintBound
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/002_RestraintBound/*conf .
            cp ../../../../../1-40winCmplx_30winLig/${val3}/2-sim_run/BFEE/002_RestraintBound/colvars*.in .
            sed -i '/indexGroup  bb/{ n; n; s/refpositionsfile  ..\/complex.xyz/refpositionsfile  ..\/..\/restraints\/complex.xyz/g }' colvars_backward.in
            sed -i '/indexGroup  bb/{ n; n; s/refpositionsfile  ..\/complex.xyz/refpositionsfile  ..\/..\/restraints\/complex.xyz/g }' colvars_forward.in
            cd ../../../..
        done
        cd ../../
    done
    cd ..
done
