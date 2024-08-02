mol new ligandOnly.pdb

[atomselect top all] writepdb ligandOnly.pdb

mol delete all

mol new fep_ligandOnly.pdb
[atomselect top all] writepdb fep_ligandOnly.pdb

exit