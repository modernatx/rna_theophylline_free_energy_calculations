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

proc get_max_dim {sel_text} {
    ## get number of frames
    set num_fr [molinfo top get numframes]

    set sel [atomselect top $sel_text]
    
    # initialize maximum x, y, z
    set x_dim_max 0
    set y_dim_max 0
    set z_dim_max 0
    for { set i 0 } { $i < $num_fr } { incr i } {
    $sel frame $i 
    
    set min_max [measure minmax $sel]
    set x_dim [expr {[lindex $min_max 1 0] - [lindex $min_max 0 0]}]
    set y_dim [expr {[lindex $min_max 1 1] - [lindex $min_max 0 1]}]
    set z_dim [expr {[lindex $min_max 1 2] - [lindex $min_max 0 2]}]
    
    if {$x_dim > $x_dim_max} { set x_dim_max $x_dim }
    if {$y_dim > $y_dim_max} { set y_dim_max $y_dim }
    if {$z_dim > $z_dim_max} { set z_dim_max $z_dim }
    }
    return [list $x_dim_max $y_dim_max $z_dim_max]
}

# load the psf and pdb file
mol load psf ../../1-sys_prep/box.psf pdb ../../1-sys_prep/box.pdb

# load the trajectory
mol addfile ../equ_2/equ.0.dcd step 50 waitfor all

# align to the first frame of rna
align "noh nucleic"

# get dimensions
set dim [get_max_dim "noh nucleic"]
puts $dim
exit
