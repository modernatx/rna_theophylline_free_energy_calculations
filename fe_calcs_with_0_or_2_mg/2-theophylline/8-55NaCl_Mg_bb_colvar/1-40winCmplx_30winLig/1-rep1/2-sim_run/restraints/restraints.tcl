## load the original pdb
mol new ../../0-starting_PDB/1o15.pdb

## select the rna and store its atoms resid and name
set sel_A    [atomselect top "noh nucleic"]
set resid_A  [$sel_A get resid]
set name_A   [$sel_A get name]


## load the pdb file fed to the NAMD conf
mol new ../../1-sys_prep/box.pdb

## select all atoms and set beta & occupancy to zero
set all [atomselect top "all"]
$all set beta 0
$all set occupancy 0

## set beta 1 for rna atoms available in original pdb
foreach resid $resid_A name $name_A {
	set mysel [atomselect top "nucleic and resid $resid and name $name"]
	$mysel set beta 1
}

## set beta 1 for the ligand
set sel_lig [atomselect top "noh resname SML MG"]
$sel_lig set beta 1

## write the pdb with assigned beta value to apply restraints
$all writepdb restraints.pdb


exit
