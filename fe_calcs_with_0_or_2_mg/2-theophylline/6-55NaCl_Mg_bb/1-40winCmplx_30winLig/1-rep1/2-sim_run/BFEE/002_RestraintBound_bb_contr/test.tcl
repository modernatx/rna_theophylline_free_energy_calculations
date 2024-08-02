source /home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files/write_index_group.tcl
mol new ../complex.pdb
set sel [atomselect top "noh nucleic"]
write_index_group test.ndx $sel "test"

exit
