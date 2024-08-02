set step 4
set add "../../6-run"
#load psf
mol load psf $add/ionized.psf

mol addfile ../1-data/wrapped_skip5.dcd step $step waitfor all

set molid 0



################## RMSD TOTAL
set seltext "protein and backbone and (helix or sheet) and not resid 178 to 186 111 300 to 327 590 599 605 609"
set ref [atomselect $molid $seltext frame 0]
set sel [atomselect $molid $seltext]
set all [atomselect $molid all]
set n [molinfo $molid get numframes]

for { set i 1 } { $i < $n } { incr i } {
	$sel frame $i   
	$all frame $i
	$all move [measure fit $sel $ref]
}


set sel_list { "name CA and protein and (helix or sheet) and not resid 178 to 186 111 300 to 327 590 599 605 609" \
"noh backbone and protein and (helix or sheet) and not resid 178 to 186 111 300 to 327 590 599 605 609" }
set output_list { "all_ca.dat" "all_bb.dat" }

foreach seltext $sel_list output $output_list {
	set fout [open "../1-data/rmsd/$output" w]
	set ref [atomselect $molid $seltext frame 0]
	set sel [atomselect $molid $seltext]
	set n [molinfo $molid get numframes]
	for { set i 1 } { $i < $n } { incr i } {
		$sel frame $i
		puts $fout "$i	[ measure rmsd $sel $ref ]"
	}
	close $fout
}

exit
