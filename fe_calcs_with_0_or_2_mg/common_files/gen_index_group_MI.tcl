source /home/misik/repos/alchemical_fe_theophylline/common_files/write_index_group.tcl
mol new ../../1-sys_prep/box.pdb
set sel [atomselect top "noh backbone nucleic"]
write_index_group colvar_index.ndx $sel "bb"

set sel2 [atomselect top "noh nucleic"]
write_index_group colvar_index.ndx $sel2 "rna"
exit