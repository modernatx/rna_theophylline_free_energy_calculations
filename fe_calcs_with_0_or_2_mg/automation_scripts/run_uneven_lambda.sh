#!/bin/bash
#####################################################################
## Setting up uneven lambda spacing for the RNA-ligand system      ##
## First (lambda: 1==>0) 20 windows: step = -0.0125		   ##
## Last 20 windows: step -0.038					   ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that will be prepared. win_list: name of the dir w/ unevne lamda-spacing
dir_list="3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine"
cond_list="4-55NaCl"
rep_list="1-rep1 2-rep2 3-rep3"
win_list="3-40winCmplx_uneven_labmda"
WD=$PWD
## make the necessary directories
mkdir -p {3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine}/4-55NaCl/3-40winCmplx_uneven_lambda/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and copy the files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/3-40winCmplx_uneven_lambda/
	## copy files and dir structure from 1-40winCmplex_30LigOnly
	rsync -r --include={"*.conf","*.pdb","*.psf","*.tcl","*.sh","*.parm7","*.inpcrd","*.ndx","*.xyz","*.in","*/"}  --exclude="*" ../1-40winCmplx_30winLig/ .
	rsync -r --include={"**/000_eq/output/*.coor","**/000_eq/output/*.vel","**/000_eq/output/*.xsc","*/"} --exclude="*" ../1-40winCmplx_30winLig/ .
	rm -rf {1-rep1,2-rep2,3-rep3}/2-sim_run/BFEE/{002_RestraintBound,003_MoleculeUnbound,004_RestraintUnbound}
	rm -rf {1-rep1,2-rep2,3-rep3}/3-analysis
	rm -rf {1-rep1,2-rep2,3-rep3}/2-sim_run/{equ_0,equ_1,equ_2,restraints,ini}
	## change lambda list for both backward and forward transformations

	## remove the defalt line for running the FEP from 1-40winCmplx_30winLig	
	sed -i 's/runFEP 1.0 0.0 -0.025 500000//' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i 's/runFEP 0.0 1.0 0.025 500000//' */2-sim_run/BFEE/001_MoleculeBound/*conf
	## define empty list: init
	sed -i '63iset init {}' */2-sim_run/BFEE/001_MoleculeBound/*conf
	## first 20 windows with -0.0125 step
	sed -i '64ifor {set i 0} {$i < 21} {incr i} {' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '65i	append init " " [expr 1.0-($i)*0.0125]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '66i}' */2-sim_run/BFEE/001_MoleculeBound/*conf
	## lambda 21: 0.725 ==> 0 with step: -0.038157894736842106
	sed -i '67iset list_bkw [concat $init [FEPlist 0.725 0 -0.038157894736842106]]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	## run FEP with the created list
	sed -i '68irunFEPlist $list_bkw 500000' */2-sim_run/BFEE/001_MoleculeBound/001.1_fep_backward.conf
	## reverse the list for the forward transformation
	sed -i '68iset list_frw [lreverse $list_bkw]' */2-sim_run/BFEE/001_MoleculeBound/001.2_fep_forward.conf
	sed -i '69irunFEPlist $list_frw 500000' */2-sim_run/BFEE/001_MoleculeBound/001.2_fep_forward.conf

        
        cd ../../
    done
    cd ..
done
