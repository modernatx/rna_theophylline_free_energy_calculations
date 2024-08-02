#################################################
## User needs to open the pdb file and identify
## the resname for the bound ligand and assign it
## to the LIG_RES variable.
#################################################
set LIG_RES "TEP"
#################################################


## load in the pdb
mol new ../0-starting_PDB/1o15.pdb

## selecting different parts of pdb
set nuc [atomselect top "nucleic"]
set water [atomselect top "water"]
set lig [atomselect top "resname $LIG_RES"]
## change ligand's resname to SML for consistency 
$lig set resname SML

## write out the separate pdb files
$nuc writepdb rna.pdb
$lig writepdb lig.pdb
$water writepdb water.pdb

exit