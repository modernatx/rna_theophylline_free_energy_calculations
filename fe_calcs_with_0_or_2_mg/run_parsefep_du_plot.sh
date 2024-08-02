#!/bin/bash

#####################################################################
## Plot dU pdfs and calculate D_KL and hellinger distance for step 002
## (FEP complex)
#####################################################################




## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
# dir_list="4-3_methylxanthine"

# cond_list="3-55NaCl_Mg/1-40winCmplx_30winLig 4-55NaCl/1-40winCmplx_30winLig 8-5NaCl_Mg_bb_colvar/1-40winCmplx_30winLig 9-5NaCl_bb_colvar/1-40winCmplx_30winLig"
# cond_list="3-55NaCl_Mg/2-80winCmplx 3-55NaCl_Mg/5-40winCmplx_2ns 8-5NaCl_Mg_bb_colvar/3-40winCmplx_2ns 8-5NaCl_Mg_bb_colvar/4-80winCmplx 9-5NaCl_bb_colvar/3-40winCmplx_2ns 9-5NaCl_bb_colvar/4-80winCmplx"
cond_list="9-5NaCl_bb_colvar/3-40winCmplx_2ns"

rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD
## set common directory path
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"

## loop over the compounds, conditions and replicas
for val1 in $dir_list; do
    for val2 in $cond_list; do
        for val3 in $rep_list; do
            mkdir -p /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/dU_plot/${val1}/${val2}/${val3}/figs
            cd /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/dU_plot/${val1}/${val2}/${val3}
            cp /home/arasouli/repos/alchemical/rna_small_molecule_FE/${val1}/${val2}/${val3}/2-sim_run/BFEE/001_MoleculeBound/output/fep_*fepout .
            cp ${cmn_dir}/run_parseFEP.tcl .
            cp ${cmn_dir}/KL_Hellinger_dU_plot.py .
            vmd -dispdev text -e run_parseFEP.tcl
            python KL_Hellinger_dU_plot.py
        done
    done
done


