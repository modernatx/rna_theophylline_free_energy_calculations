#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
# dir_list=" 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
dir_list=" 2-theophylline "
cond_list="1-55NaCl_3Mg"
rep_list="1-rep1 2-rep2 3-rep3"

#cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

WD=$PWD



## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        echo ${val1},${val2}
        for val3 in $rep_list; do
            cd ${val3}/1-sys_prep
            echo ${val3}
            
            vmd -dispdev text -e 0-add_Mg.tcl > 0-add_Mg.log
            vmd -dispdev text -e 1-extract_lig_pdb_resname.tcl > 1-extract_lig_pdb_resname.log
            # vmd -dispdev text -e 1-ligand_fit.tcl > 1-ligand_fit.log
            source 2-run_system_setup.sh >& 2-run_system_setup.log
            python 3-gen_psf.py
            cd ../2-sim_run/restraints/
            vmd -dispdev text -e restraints.tcl > restraints.log
               
            cd ../../..
        done
        cd ../../
    done
    cd ..
done
