#!/bin/bash

#####################################################################
## This script makes directoris and runs RMSD analysis.            ##
#####################################################################


## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that needs to be analyzed
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="2-Neut_3Mg"
win_list="1-40winCmplx_30winLig"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD

## set common_files directory path
#cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

## loop over the compounds, conditions and replicas
## and setup the directories and run rmsd.tcl


for val1 in $dir_list; do
   cd ${val1}
   for val2 in $cond_list; do
        cd ${val2}/
        for val4 in $win_list;do
            cd ${val4}
            for val3 in $rep_list; do
                cd ${val3}/1-sys_prep
                cp ${cmn_dir}/3-gen_psf.py .
                python 3-gen_psf.py
                cd ../../
                ## creat the necessary directories
                mkdir -p ${val3}/3-analysis/rmsd
                cd ${val3}/3-analysis/rmsd
                ## copy the analysis script
                cp ${cmn_dir}/rmsd.tcl .
                ## run the analysis w/ VMD (VMD needs to be installed
                ## and its path added to $PATH)
                vmd -dispdev text -e rmsd.tcl 
                cd ../../../
            done
            cd ../
        done
        cd ../
    done
    cd ..
done

## loop over the compounds, conditions and replicas
## and setup the directories and plot rmsd
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}
            for val4 in $win_list;do
                cd ${val4}
                for val3 in $rep_list; do
                    ## creat the necessary directories
                    mkdir -p ${val3}/3-analysis/plot
                    cd ${val3}/3-analysis/plot
                    ## copy the plotting script
                    cp ${cmn_dir}/rmsd_plot.py .
                    cp ${cmn_dir}/rmsd_cat.sh .
                    source rmsd_cat.sh
                    # generate the plots
                    python rmsd_plot.py 
                    cd ../../../
                done
            cd ../
        done
        cd ../
    done
    cd ..
done

# for val1 in $dir_list; do
#     cd ${val1}
#     for val2 in $cond_list; do
#         cd ${val2}/1-40winCmplx_30winLig/
#         for val3 in $rep_list; do
        
#             cd ${val3}/3-analysis/plot
#             cp rmsd.pdf /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/rmsd/figs_noMg_24/${val1}_${val2}_${val3}.pdf
            
#             cp rmsd_bb.pdf /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/rmsd/figs_bb_noMg_24/${val1}_${val2}_${val3}_bb.pdf

#             cd ../../../
#             done
#             cd ../../
#     done
#     cd ..
# done
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}
            for val4 in $win_list;do
                cd ${val4}
                for val3 in $rep_list; do
                    cd ${val3}/3-analysis/plot
                    # cp rmsd.pdf /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/rmsd/figs_final/${val4}_${val1}_${val2}_${val3}.pdf
                                        cp rmsd_bb.pdf /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/rmsd/figs_final/bb_${val4}_${val1}_${val2}_${val3}.pdf

 
                    cd ../../../
                done
            cd ../
        done
        cd ../
    done
    cd ..
done
