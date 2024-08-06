#!/bin/bash

#####################################################################
## Sets up simulation and creates the directories and files for backbone 
## restrained RNA using the COLVAR module of NAMD.
## 
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="6-xanthine" #"2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="4-55NaCl_3Mg_bb_colvar"
rep_list="4-rep4" #"1-rep1 2-rep2 3-rep3"

#cmn_dir="/home/misik/repos/3_mg_rna_small_molecule_fe/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

WD=$PWD

## loop over the compounds, conditions and replicais
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            mkdir -p ${val3}
            cd ${val3}/
            echo ${val1}, ${val2}, ${val3}
            echo "PWD:", $PWD
            cp -r ../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/1-rep1/0-starting_PDB/ .
            cp -r ../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/1-rep1/1-sys_prep/ .
            
            mkdir -p ./2-sim_run/{equ_0,equ_1}
            
            cp -r ${cmn_dir}/bb_colvar_min.0.conf ./2-sim_run/equ_0/min.0.conf
            cp -r ${cmn_dir}/bb_colvar_equ.0.conf ./2-sim_run/equ_0/equ.0.conf
            cp -r ${cmn_dir}/bb_colvar_equ.0_2.conf ./2-sim_run/equ_1/equ.0.conf
            
            cp -r ../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints ./2-sim_run
            ## Not running restraints.tcl here because the simulation box is the same 1-55NaCl_3Mg
            # cd 2-sim_run/restraints
            # rm -f restraints.pdb
            # vmd -dispdev text -e restraints.tcl 
            # cd ../../
            
            # cp ${cmn_dir}/tleap_noMg.in ./1-sys_prep/tleap.in
            # cd ./1-sys_prep
            # rm -f ./2-run_system_setup.log ./box.psf
            # chmod +x ./2-run_system_setup.sh
            # ./2-run_system_setup.sh > 2-run_system_setup.log
            # python 3-gen_psf.py
            # cd ../
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
