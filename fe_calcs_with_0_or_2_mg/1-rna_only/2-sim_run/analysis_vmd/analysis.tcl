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

# load the psf and pdb file
mol load psf ../../1-sys_prep/box.psf pdb ../../1-sys_prep/box.pdb

# load the trajectory
mol addfile ../equ_2/equ.0.dcd step 20 waitfor all

# align to the first frame of rna
align "noh nucleic"

# selection text list for rmsd 
set sel_list { "noh nucleic"  }
# output files for rmsd
set output_list { "rna_rmsd.dat" }

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

exit
