source /home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files/write_index_group.tcl
mol new ../../1-sys_prep/box.pdb
set sel [atomselect top "noh backbone nucleic"]
write_index_group bb.ndx $sel "bb"

exit
