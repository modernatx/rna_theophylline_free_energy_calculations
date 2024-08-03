#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list1=" 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
dir_list2=" 2-theophylline "
cond_list="3-55KCl_3Mg"
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
WD=$PWD



# loop over the compounds, conditions and replicas
# and copy files over
for val1 in $dir_list1; do
    cd ${val1}
    for val2 in $cond_list; do
        mkdir -p ${val2}
        cd ${val2}/
        mkdir 1-40winCmplx_30winLig/
        cd 1-40winCmplx_30winLig/
        echo ${val1},${val2}
        for val3 in $rep_list; do
            mkdir ${val3}
            cd ${val3}/
            echo ${val3}
            cp -r ../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/0-starting_PDB .
            mkdir -p 1-sys_prep
            cd 1-sys_prep
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*tcl .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*sh .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/tleap.in .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*py .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*pdb .
            rm -f box.pdb sqm.pdb lig.pdb lig_sqm.pdb rna_noH.pdb rna_noH_nonprot.pdb *log *out *psf
            sed -i 's/addionsRand mybox Na+ 11//g' tleap.in
            sed -i 's/addionsRand mybox Cl- 11//g' tleap.in
    
            vmd -dispdev text -e 0-add_Mg.tcl > 0-add_Mg.log
            vmd -dispdev text -e 1-ligand_fit.tcl > 1-ligand_fit.log
            source 2-run_system_setup.sh >& 2-run_system_setup.log
            python 3-gen_psf.py
            
            cd ../
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


## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list2; do
    cd ${val1}
    for val2 in $cond_list; do
        mkdir -p ${val2}
        cd ${val2}/
        mkdir 1-40winCmplx_30winLig/
        cd 1-40winCmplx_30winLig/
        echo ${val1},${val2}
        for val3 in $rep_list; do
            mkdir ${val3}
            cd ${val3}/
            echo ${val3}
            cp -r ../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/0-starting_PDB .
            mkdir -p 1-sys_prep
            cd 1-sys_prep
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*tcl .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*sh .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/tleap.in .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*py .
            cp ../../../../1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/*pdb .
            rm -f box.pdb sqm.pdb lig.pdb lig_sqm.pdb rna_noH.pdb rna_noH_nonprot.pdb *log *out *psf
            sed -i 's/addionsRand mybox Na+ 11//g' tleap.in
            sed -i 's/addionsRand mybox Cl- 11//g' tleap.in
    
            vmd -dispdev text -e 0-add_Mg.tcl > 0-add_Mg.log
            vmd -dispdev text -e 1-extract_lig_pdb_resname.tcl > 1-extract_lig_pdb_resname.log
            source 2-run_system_setup.sh >& 2-run_system_setup.log
            python 3-gen_psf.py
            
            cd ../
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