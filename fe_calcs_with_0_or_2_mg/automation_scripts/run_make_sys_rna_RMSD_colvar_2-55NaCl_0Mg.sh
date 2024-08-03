#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list1=" 8-rna_RMSD_colvar_contr "
cond_list=" 2-55NaCl_0Mg "
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/misik/repos/alchemical_fe_theophylline/common_files"
WD=$PWD


# loop over all the compounds except tehophylline, conditions and replicas
# and copy files over
for val1 in $dir_list1; do
    cd ${val1}
    for val2 in $cond_list; do
        mkdir -p ${val2}
        cd ${val2}/
        mkdir 1-40win/
        cd 1-40win/
        echo ${val1},${val2}
        for val3 in $rep_list; do
            mkdir ${val3}
            cd ${val3}/
            echo ${val3}
            
            # Copy 0-starting_PDB files
            cp -r ../../../1-55NaCl_2Mg/1-40win/${val3}/0-starting_PDB .
    
            # Copy 1-sys_prep files
            mkdir -p 1-sys_prep
            cd 1-sys_prep
            cp ../../../../1-55NaCl_2Mg/1-40win/${val3}/1-sys_prep/*tcl .
            cp ../../../../1-55NaCl_2Mg/1-40win/${val3}/1-sys_prep/*sh .
            cp ../../../../1-55NaCl_2Mg/1-40win/${val3}/1-sys_prep/tleap.in .
            cp ../../../../1-55NaCl_2Mg/1-40win/${val3}/1-sys_prep/*py .
            cp ../../../../1-55NaCl_2Mg/1-40win/${val3}/1-sys_prep/*pdb .
            rm -f box.pdb sqm.pdb lig.pdb lig_sqm.pdb rna_noH.pdb rna_noH_nonprot.pdb *log *out *psf
            # Remove Mg+2 ions from tleap.in
            sed -i 's/mybox = combine { rna  mg1  mg3 }/mybox = combine { rna }/g' tleap.in
    
            # We don't have ligand or Mg+2 in this system, just RNA            
            #vmd -dispdev text -e 0-add_Mg.tcl > 0-add_Mg.log
            #vmd -dispdev text -e 1-ligand_fit.tcl > 1-ligand_fit.log
            
            # Run system setup
            source 2-run_system_setup.sh >& 2-run_system_setup.log
            python 3-gen_psf.py
            
            # Copy 2-sim_run files
            cd ../
            mkdir -p 2-sim_run/{equ_0,equ_1}
            cd 2-sim_run
            cp -r ../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/equ_0/*conf equ_0
            cp -r ../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/equ_1/*conf equ_1
            # Equ_2 doesn't exist for equilibration with backbone restraints
            #cp -r ../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/equ_2/*conf equ_2
            
            # Copy bb_colvars.in
            cd equ_1/
            cp ../../../../../../common_files/bb_colvars.in .    

            # Copy run files 
            cd ../
            cp ../../../../../common_files/run_1_bb_colvar_equ_MI.sh .
            cp ../../../../../common_files/run_bb_contr_MI.sh .

            # Copy wrap_rna_only.tcl
            cp ../../../../../common_files/wrap_rna_only.tcl .

            # Copy restraints directory and run scripts that define restrained atoms
            cp -r ../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/restraints .
            
            cd restraints/
            rm -f *pdb *log
            vmd -dispdev text -e restraints.tcl > restraints.log

            # Copy files from contribution_RMSD_ref_wrap directory for bacbbone restrain TI calculation
            cd ..
            mkdir -p contribution_RMSD_ref_wrap
            cd contribution_RMSD_ref_wrap
            cp -r ../../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/contribution_RMSD_ref_wrap/*.in .
            cp -r ../../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/contribution_RMSD_ref_wrap/*.conf .
            cp -r ../../../../../../common_files/gen_index_group_MI.tcl .
            cp -r ../../../../../1-55NaCl_2Mg/1-40win/${val3}/2-sim_run/contribution_RMSD/*.py .
            mkdir -p output

            cd ../../../
        done
        cd ../../
    done
    cd ..
done


