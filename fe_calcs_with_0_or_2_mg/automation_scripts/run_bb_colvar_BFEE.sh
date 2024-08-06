#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="5-hypoxanthine"
cond_list="8-5NaCl_Mg_bb_colvar"
rep_list="2-rep2 3-rep3 "

# cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"

WD=$PWD



## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            cat ../restraints/bb.ndx >> complex.ndx
            sed -i '4icolvar {\n    name RMSD_bb\n    rmsd {\n        atoms {\n            indexGroup  bb\n}\n        refpositionsfile  ../complex.xyz\n    }\n}\n\nharmonic {\n    colvars         RMSD_bb\n    forceConstant   10.0\n    centers         0.0\n}' 000_eq/colvars.in            
            sed -i '4icolvar {\n    name RMSD_bb\n    rmsd {\n        atoms {\n            indexGroup  bb\n}\n        refpositionsfile  ../complex.xyz\n    }\n}\n\nharmonic {\n    colvars         RMSD_bb\n    forceConstant   10.0\n    centers         0.0\n}' 001_MoleculeBound/colvars.in
            sed -i '4icolvar {\n    name RMSD_bb\n    rmsd {\n        atoms {\n            indexGroup  bb\n}\n        refpositionsfile  ../complex.xyz\n    }\n}\n\nharmonic {\n    colvars         RMSD_bb\n    forceConstant   0.0\n    centers         0.0\n    targetNumSteps      500000\n    targetEquilSteps    100000\n    targetForceConstant 10.0\n    targetForceExponent 4\n    lambdaSchedule 1.0 0.975 0.95 0.925 0.9 0.875 0.85 0.825 0.8 0.775 0.75 0.725 0.7 0.675 0.65 0.625 0.6 0.575 0.55 0.525 0.5 0.475 0.45 0.425 0.4 0.375 0.35 0.325 0.3 0.275 0.25 0.225 0.2 0.175 0.15 0.125 0.1 0.075 0.05 0.025 0.0\n}' 002_RestraintBound/colvars_backward.in
            sed -i '4icolvar {\n    name RMSD_bb\n    rmsd {\n        atoms {\n            indexGroup  bb\n}\n        refpositionsfile  ../complex.xyz\n    }\n}\n\nharmonic {\n    colvars         RMSD_bb\n    forceConstant   0.0\n    centers         0.0\n    targetNumSteps      500000\n    targetEquilSteps    100000\n    targetForceConstant 10.0\n    targetForceExponent 4\n    lambdaSchedule 0.0 0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.825 0.85 0.875 0.9 0.925 0.95 0.975 1.0\n}' 002_RestraintBound/colvars_forward.in
           
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
