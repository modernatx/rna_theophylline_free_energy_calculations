#!/bin/bash
#####################################################################
## Setting up uneven lambda spacing for the RNA-ligand system      ##
## First (lambda: 1==>0) 15-15-10 scheme.				   ##
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that will be prepared. win_list: name of the dir w/ unevne lamda-spacing
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="4-55NaCl"
rep_list="1-rep1 2-rep2 3-rep3"
win_list="4-40winCmplx_uneven_labmda_15_15_10"
WD=$PWD
## make the necessary directories
mkdir -p {2-theophylline,3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine,6-xanthine,7-caffeine}/4-55NaCl/4-40winCmplx_uneven_labmda_15_15_10/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and copy the files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/4-40winCmplx_uneven_labmda_15_15_10/
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
	## define min and max step size
	sed -i '63iset min_step 0.016666666666666666' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '64iset max_step 0.03333333' */2-sim_run/BFEE/001_MoleculeBound/*conf

	sed -i '65iset seq2 {}' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '66iset x_max 0.75' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '67iset x_min 0.33333333' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '68iset n 15' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '69iset incr_ [expr ($x_max - $x_min - $n * $min_step) * (2.0/$n/($n-1))]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '70iset x $x_max' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '71ifor {set i 0} {$i < $n-1} {incr i} {' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '72i    set step [expr $min_step + ($i * $incr_)]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '73i    set x [expr $x - $step]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '74i    append seq2 " " $x' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '75i    }' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '76iset list_bkw [concat [FEPlist 1 0.75 -$min_step] $seq2 [FEPlist $x_min 0 -$max_step]]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i '77iset list_bkw [lreplace $list_bkw 40 40 0]' */2-sim_run/BFEE/001_MoleculeBound/*conf
	## run FEP with the created list
	sed -i '78irunFEPlist $list_bkw 500000' */2-sim_run/BFEE/001_MoleculeBound/001.1_fep_backward.conf
	## reverse the list for the forward transformation
	sed -i '78iset list_frw [lreverse $list_bkw]' */2-sim_run/BFEE/001_MoleculeBound/001.2_fep_forward.conf
	sed -i '79irunFEPlist $list_frw 500000' */2-sim_run/BFEE/001_MoleculeBound/001.2_fep_forward.conf

        
        cd ../../
    done
    cd ..
done
