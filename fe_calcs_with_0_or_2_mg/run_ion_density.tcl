proc align {sel_text} {
    ## get number of frames
    set num_fr [molinfo top get numframes]

    set ref [atomselect top $sel_text frame 0]
    set sel [atomselect top $sel_text]
    set all [atomselect top all]

    for { set i 1 } { $i < $num_fr } { incr i } {
    $sel frame $i
    $all frame $i
    $all move [measure fit $sel $ref]
    }
}

set dir_list { 2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine }
set cond_list { 4-55NaCl }
# set rep_list {1-rep1 2-rep2 3-rep3}
package require pbctools
foreach val1 $dir_list {
	foreach val2 $cond_list {
		cd ${val1}/${val2}/1-40winCmplx_30winLig/
		mol load psf 1-rep1/1-sys_prep/box.psf pdb 1-rep1/1-sys_prep/box.pdb
		mol addfile 1-rep1/2-sim_run/equ_2/equ.0.dcd step 50 waitfor all
        # mol addfile 1-rep1/2-sim_run/equ_2/equ.1.dcd step 50 waitfor all
		mol addfile 2-rep2/2-sim_run/equ_2/equ.0.dcd step 50 waitfor all
        # mol addfile 2-rep2/2-sim_run/equ_2/equ.1.dcd step 50 waitfor all
		mol addfile 3-rep3/2-sim_run/equ_2/equ.0.dcd step 50 waitfor all
        # mol addfile 3-rep3/2-sim_run/equ_2/equ.1.dcd step 50 waitfor all
		pbc wrap -all -center com -centersel nucleic -compound resid
		align "noh nucleic and backbone"
		# volmap density [atomselect top "type KP"] -res 0.5 -weight mass -allframes -combine avg -o /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/ion_density/${val1}_${val2}.dx
        set sel [atomselect top "type NAPLTU"]
        $sel set radius 1
        volmap density $sel -res 0.5 -allframes -combine avg -o /home/arasouli/repos/alchemical/rna_small_molecule_FE/results/ion_density_scaled/${val1}_${val2}.dx
		mol delete all
	}
	cd ../../../
}

exit
