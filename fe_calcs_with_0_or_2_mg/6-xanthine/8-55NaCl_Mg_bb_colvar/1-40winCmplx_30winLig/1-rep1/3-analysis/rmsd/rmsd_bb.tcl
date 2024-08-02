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
package require pbctools
###############################################################
## load pre-equil and calculate rmsd
###############################################################
mol load psf ../../1-sys_prep/box.psf pdb ../../1-sys_prep/box.pdb
mol addfile ../../2-sim_run/equ_0/equ.0.dcd step 50 waitfor all
mol addfile ../../2-sim_run/equ_1/equ.0.dcd step 50 waitfor all


pbc unwrap -sel "nucleic or resname SML MG"

# align to the first frame of rna
align "noh nucleic and backbone"

# selection text list for rmsd 
set sel_list { "noh nucleic" "noh nucleic and backbone" "noh resname SML"}
# output files for rmsd 
set output_list { "0-rna_rmsd.dat" "0-rna_bb_rmsd.dat" "0-lig_rmsd.dat" }

foreach seltext $sel_list output $output_list {
    set fout [open "$output" w]
    set ref [atomselect top $seltext frame 0]
    set sel [atomselect top $seltext]
    set n [molinfo top get numframes]
    for { set i 0 } { $i < $n } { incr i } {
        $sel frame $i
        puts $fout "$i   [ measure rmsd $sel $ref ]"
    }
    close $fout
}
###############################################################
## load bfee-equil and calculate rmsd
###############################################################
mol load psf ../../1-sys_prep/box.psf pdb ../../1-sys_prep/box.pdb
mol addfile ../../2-sim_run/BFEE/000_eq/output/eq.dcd step 50 waitfor all

# align to the first frame of rna
align "noh nucleic and backbone"

# selection text list for rmsd 
set sel_list { "noh nucleic" "noh nucleic and backbone" "noh resname SML" "resname MG and resid 35" "resname MG and resid 36"}
# output files for rmsd 
set output_list { "1-rna_rmsd.dat" "1-rna_bb_rmsd.dat" "1-lig_rmsd.dat" "1-Mg1_rmsd.dat" "1-Mg2_rmsd.dat"}

foreach seltext $sel_list output $output_list {
    set fout [open "$output" w]
    set ref [atomselect top $seltext frame 0]
    set sel [atomselect top $seltext]
    set n [molinfo top get numframes]
    for { set i 1 } { $i < $n } { incr i } {
        $sel frame $i
        puts $fout "$i   [ measure rmsd $sel $ref ]"
    }
    close $fout
}
###############################################################
## load bfee-complex FEP and calculate rmsd
###############################################################
mol load psf ../../1-sys_prep/box.psf pdb ../../1-sys_prep/box.pdb
mol addfile ../../2-sim_run/BFEE/001_MoleculeBound/output/fep_backward.dcd step 50 waitfor all
mol addfile ../../2-sim_run/BFEE/001_MoleculeBound/output/fep_forward.dcd step 50 waitfor all

# align to the first frame of rna
align "noh nucleic and backbone"

# selection text list for rmsd 
set sel_list { "noh nucleic" "noh nucleic and backbone" "noh resname SML" "resname MG and resid 35" "resname MG and resid 36"}
# output files for rmsd 
set output_list { "2-rna_rmsd.dat" "2-rna_bb_rmsd.dat" "2-lig_rmsd.dat" "2-Mg1_rmsd.dat" "2-Mg2_rmsd.dat"}

foreach seltext $sel_list output $output_list {
    set fout [open "$output" w]
    set ref [atomselect top $seltext frame 0]
    set sel [atomselect top $seltext]
    set n [molinfo top get numframes]
    for { set i 1 } { $i < $n } { incr i } {
        $sel frame $i
        puts $fout "$i   [ measure rmsd $sel $ref ]"
    }
    close $fout
}
###############################################################
## load bfee-complex TI and calculate rmsd
###############################################################
mol load psf ../../1-sys_prep/box.psf pdb ../../1-sys_prep/box.pdb
mol addfile ../../2-sim_run/BFEE/002_RestraintBound/output/ti_backward.dcd step 50 waitfor all
mol addfile ../../2-sim_run/BFEE/002_RestraintBound/output/ti_forward.dcd step 50 waitfor all

# align to the first frame of rna
align "noh nucleic and backbone"

# selection text list for rmsd 
set sel_list { "noh nucleic" "noh nucleic and backbone" "noh resname SML" "resname MG and resid 35" "resname MG and resid 36"}
# output files for rmsd 
set output_list { "3-rna_rmsd.dat" "3-rna_bb_rmsd.dat" "3-lig_rmsd.dat" "3-Mg1_rmsd.dat" "3-Mg2_rmsd.dat"}

foreach seltext $sel_list output $output_list {
    set fout [open "$output" w]
    set ref [atomselect top $seltext frame 0]
    set sel [atomselect top $seltext]
    set n [molinfo top get numframes]
    for { set i 1 } { $i < $n } { incr i } {
        $sel frame $i
        puts $fout "$i   [ measure rmsd $sel $ref ]"
    }
    close $fout
}

exit
