#!/bin/bash

#####################################################################
## This script generates complex.xyz file (as a reference in the colvar)
## and also an index file to specify atoms invloved in the RMSD colvar.
## It also adds the keywords to NAMD conf files for colvars.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="10-55KCl_Mg"
rep_list="1-rep1 2-rep2 3-rep3"

# cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"

WD=$PWD

# mkdir -p {2-theophylline,3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine,6-xanthine,7-caffeine}/10-55KCl_Mg/1-40winCmplx_30winLig/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and genrate xyz and ndx files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
#             cp -r ../../../1-150KCl_Mg/1-40winCmplx_30winLig/${val3}/0-starting_PDB .
#             cp -r ../../../1-150KCl_Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep .
    
#             cd 1-sys_prep
#             rm -f 2-run_system_setup.log
#             rm -f box.psf
#             cp ${cmn_dir}/2-run_system_setup.sh .
#             cp ${cmn_dir}/tleap_55KCl.in ./tleap.in
#             source 2-run_system_setup.sh > 2-run_system_setup.log
#             python 3-gen_psf.py
#             cd ../
            
#             mkdir -p 2-sim_run/{equ_0,equ_1,equ_2}
            cp /home/arasouli/repos/alchemical/rna_small_molecule_FE/equ.1.conf 2-sim_run/equ_2
            cp /home/arasouli/repos/alchemical/rna_small_molecule_FE/run_1.sh 2-sim_run/run_1.sh
#             cp ../../../../5-hypoxanthine/3-55NaCl_Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_0/*conf 2-sim_run/equ_0
#             cp ../../../../5-hypoxanthine/3-55NaCl_Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_1/*conf 2-sim_run/equ_1
#             cp ../../../../5-hypoxanthine/3-55NaCl_Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_2/*conf 2-sim_run/equ_2
#             cp -r ../../../../5-hypoxanthine/3-55NaCl_Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/restraints 2-sim_run
#             cd 2-sim_run/restraints
#             rm *pdb
#             vmd -dispdev text -e restraints.tcl
#             cd ../../
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
