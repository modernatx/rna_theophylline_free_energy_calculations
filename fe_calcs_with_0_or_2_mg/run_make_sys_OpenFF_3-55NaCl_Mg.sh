#!/bin/bash

#conda install -c conda-forge openff-toolkit
conda activate openff
conda list -e > requirements_openff.txt
conda env export > requirements_openff.yml

#####################################################################
## make directories for OpenFF simulations with 55 mM NaCl and 2 Mg.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="3-55NaCl_Mg"
rep_list="1-rep1 2-rep2 3-rep3"
#cmn_dir="/home/arasouli/repos/alchemical/alchemical_fe_theophylline/common_files"
cmn_dir="/home/misik/repos/alchemical_fe_theophylline/common_files"

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
            cp -r ../../../3-55NaCl_Mg/1-40winCmplx_30winLig/${val3}/0-starting_PDB .

            ## Recreate system prep directory instead of copying over because we need to redo this with 
            ## OpenFF parametrization
            rm -r 1-sys_prep
            mkdir -p 1-sys_prep
            cd 1-sys_prep
            ## Rename old box.prmtop as box_gaff.prmtop, so that we only use them as input for parametrization.
            cp ../../../../3-55NaCl_Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/box.prmtop box_gaff.prmtop
            cp ../../../../3-55NaCl_Mg/1-40winCmplx_30winLig/${val3}/1-sys_prep/box.inpcrd box_gaff.inpcrd
            
            # Copy sdf files over
            cp ${cmn_dir}/sdf_files/${val1}.sdf .
            
            # This script generates box.prmtop and box.pdb with OpenFF parametrization.
            cp ${cmn_dir}/gen_openFF.py .
            # Run gen_openFF with ligand SDF file as argument
            python gen_openFF.py -s ${val1}.sdf > gen_openFF.log
            
            # Rewrite OpenFF PDB with VMD to correct atom numbering issues in ter line
            cp ${cmn_dir}/fix_openff_pdb.tcl .
            vmd -dispdev text -e fix_openff_pdb.tcl
    
            cd ../
            rm -r 2-sim_run
            mkdir -p 2-sim_run/{equ_0,equ_1,equ_2}
            cd 2-sim_run
	        # Copy conf files from the other repository to use the updated version (VDW switching on)
	        # Don't forget to update cell basis vectors in minimization conf file (either fix with sed or create a reference file common to all ligand).
            cp $cmn_dir/min.0.conf equ_0/
            cp -r ../../../../../../3_mg_rna_small_molecule_fe/${val1}/1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/equ_0/equ.0.conf equ_0
            cp -r ../../../../../../3_mg_rna_small_molecule_fe/${val1}/1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/equ_1/*conf equ_1
            cp -r ../../../../../../3_mg_rna_small_molecule_fe/${val1}/1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/equ_2/*conf equ_2
            cp -r ../../../../../../3_mg_rna_small_molecule_fe/${val1}/1-55NaCl_3Mg/1-40winCmplx_30winLig/${val3}/2-sim_run/restraints .
            
            # Write restraints.pdb for atoms that will experience restraints during equilibration
            cd restraints/
            rm -f *pdb *log
            vmd -dispdev text -e restraints.tcl > restraints.log
               
            cd ../../..
        done
        cd ../../
    done
    cd ..
done
