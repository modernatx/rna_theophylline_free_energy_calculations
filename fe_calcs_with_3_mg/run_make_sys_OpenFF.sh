#!/bin/bash

#####################################################################
## make directories for OpenFF simulations with 55 mM NaCl and 3 Mg.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="1-55NaCl_3Mg"
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
WD=$PWD


# loop over the compounds, conditions and replicas
# and copy files over 
for val1 in $dir_list; do
    echo ${val1}
    cd ${val1}
    for val2 in $cond_list; do
        mkdir -p ${val2}
        cd ${val2}/
        mkdir -p 2-OpenFF_40winCmplx_30winLig/
        cd 2-OpenFF_40winCmplx_30winLig/
        echo ${val1},${val2}
        for val3 in $rep_list; do
            mkdir -p ${val3}
            cd ${val3}/
            echo ${val3}
            cp -r ../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/0-starting_PDB .
            rm -r 1-sys_prep
            mkdir -p 1-sys_prep
            cd 1-sys_prep
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/box.prmtop box_gaff.prmtop
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/box.inpcrd box_gaff.inpcrd
            

            cp ${cmn_dir}/sdf_files/${val1}.sdf .
            
            cp ${cmn_dir}/gen_openFF.py . > gen_openFF.log
            
            python gen_openFF.py -s ${val1}.sdf
            
            cp ${cmn_dir}/fix_openff_pdb.tcl .
            vmd -dispdev text -e fix_openff_pdb.tcl
    

            
            cd ../
            rm -r 2-sim_run
            mkdir -p 2-sim_run/{equ_0,equ_1,equ_2}
            cd 2-sim_run
            cp -r ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/equ_0/*conf equ_0
            cp -r ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/equ_1/*conf equ_1
            cp -r ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/equ_2/*conf equ_2
            cp -r ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/restraints .
            
            
            cd restraints/
            rm -f *pdb *log
            vmd -dispdev text -e restraints.tcl > restraints.log
               
            cd ../../..
        done
        cd ../../
    done
    cd ..
done