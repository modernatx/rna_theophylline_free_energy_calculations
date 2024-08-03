#!/bin/bash
#####################################################################
## Setting 40 even lambdas that are each run 2 ns. Based on previous 
## simulations with 40 wins of 1 ns and change the simualtions time 
## for each window to 2ns. 
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that will be prepared. win_list: name of the dir w/ unevne lamda-spacing
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="8-5NaCl_Mg_bb_colvar" # cond_list="3-55NaCl_Mg"
rep_list="1-rep1 2-rep2 3-rep3"
win_list="3-40winCmplx_2ns"
WD=$PWD
## make the necessary directories
mkdir -p {2-theophylline,3-1_methylxanthine,4-3_methylxanthine,5-hypoxanthine,6-xanthine,7-caffeine}/8-5NaCl_Mg_bb_colvar/3-40winCmplx_2ns/{1-rep1,2-rep2,3-rep3}

## loop over the compounds, conditions and replicas
## and copy the files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/3-40winCmplx_2ns/
	## copy files and dir structure from 1-40winCmplex_30LigOnly
	rsync -r --include={"*.conf","*.pdb","*.psf","*.tcl","*.sh","*.parm7","*.inpcrd","*.ndx","*.xyz","*.in","*/"}  --exclude="*" ../1-40winCmplx_30winLig/ .
	rsync -r --include={"**/000_eq/output/*.coor","**/000_eq/output/*.vel","**/000_eq/output/*.xsc","*/"} --exclude="*" ../1-40winCmplx_30winLig/ .
	rm -rf {1-rep1,2-rep2,3-rep3}/2-sim_run/BFEE/{002_RestraintBound,003_MoleculeUnbound,004_RestraintUnbound}
	rm -rf {1-rep1,2-rep2,3-rep3}/3-analysis
	rm -rf {1-rep1,2-rep2,3-rep3}/2-sim_run/{equ_0,equ_1,equ_2,restraints,ini}
	## change lambda list for both backward and forward transformations

	## remove the defalt line for running the FEP from 1-40winCmplx_30winLig	
	sed -i 's/alchEquilSteps 100000/alchEquilSteps 200000/' */2-sim_run/BFEE/001_MoleculeBound/*conf    
	sed -i 's/runFEP 1.0 0.0 -0.025 500000/runFEP 1.0 0.0 -0.025 1000000/' */2-sim_run/BFEE/001_MoleculeBound/*conf
	sed -i 's/runFEP 0.0 1.0 0.025 500000/runFEP 0.0 1.0 0.025 1000000/' */2-sim_run/BFEE/001_MoleculeBound/*conf  

        cd ../../
    done
    cd ..
done
