#!/bin/bash

#####################################################################
## Sets up simulation for backbone restrained RNA using the COLVAR
## module of NAMD.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="9-5NaCl_bb_colvar"
# 6-opc_40winCmplx_30winLig
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
WD=$PWD

mkdir -p {2-theophylline,3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine,6-xanthine,7-caffeine}/9-5NaCl_bb_colvar/1-40winCmplx_30winLig/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
            cp -r ../../../4-55NaCl/1-40winCmplx_30winLig/${val3}/0-starting_PDB/ .
            cp -r ../../../4-55NaCl/1-40winCmplx_30winLig/${val3}/1-sys_prep/ .
            
            mkdir -p ./2-sim_run/{equ_0,equ_1}
            
            cp -r ${cmn_dir}/min.0.conf ./2-sim_run/equ_0
            cp -r ${cmn_dir}/equ.0.conf ./2-sim_run/equ_0
            cp -r ${cmn_dir}/equ.0_2.conf ./2-sim_run/equ_1/equ.0.conf
            
            cp -r ../../../4-55NaCl/1-40winCmplx_30winLig/${val3}/2-sim_run/restraints ./2-sim_run
            cd 2-sim_run/restraints
            rm -f restraints.pdb
            vmd -dispdev text -e restraints.tcl 
            cd ../../
            
            # cp ${cmn_dir}/tleap_noMg.in ./1-sys_prep/tleap.in
            # cd ./1-sys_prep
            # rm -f ./2-run_system_setup.log ./box.psf
            # chmod +x ./2-run_system_setup.sh
            # ./2-run_system_setup.sh > 2-run_system_setup.log
            # python 3-gen_psf.py
            cd ../
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
