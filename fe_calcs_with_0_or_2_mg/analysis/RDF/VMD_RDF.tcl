set dir_list { 2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine }
set cond_list { 3-55NaCl_Mg }
cd /home/arasouli/repos/alchemical/rna_small_molecule_FE

foreach val1 $dir_list {
	foreach val2 $cond_list {
		cd ${val1}/${val2}/6-opc_40winCmplx_30winLig/
		mol load psf 1-rep1/1-sys_prep/box.psf
		mol addfile 1-rep1/2-sim_run/equ_2/equ.0.dcd step 50 waitfor all
		mol addfile 2-rep2/2-sim_run/equ_2/equ.0.dcd step 50 waitfor all
		mol addfile 3-rep3/2-sim_run/equ_2/equ.0.dcd step 50 waitfor all

        set obj1_sel [atomselect top "type NAPLTU"]
        set obj2_sel [atomselect top "(nucleic or resname G5 C3) and name OP1 OP2"]
        set gr [measure gofr $obj1_sel $obj2_sel delta .1 rmax 10 first 0 last -1 step 1 usepbc TRUE]
        
        set r [lindex $gr 0]
        set gr2 [lindex $gr 1]
        set igr [lindex $gr 2]
        

        set fout [open "/home/arasouli/repos/alchemical/rna_small_molecule_FE/analysis/RDF/vmd_rdfs/${val1}_${val2}_OPC.txt" w]
        foreach j $r k $gr2 l $igr {
           puts $fout "$j $k $l"
        }
    }
    cd ../../..
        close $fout
}

exit