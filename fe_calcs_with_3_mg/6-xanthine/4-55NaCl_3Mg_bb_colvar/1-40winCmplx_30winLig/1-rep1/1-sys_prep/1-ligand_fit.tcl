#################################################
## User needs to open the pdb file and identify
## a few atoms from theophylline and its analog
## to fit them on top of eachother
#################################################



## load in the pdb containg TEP
set tep_mol [mol new ../0-starting_PDB/1o15.pdb]

## selecting different parts of pdb
set nuc [atomselect $tep_mol "nucleic"]
set water [atomselect $tep_mol "water"]


## write out the separate pdb files
$nuc writepdb rna.pdb
$water writepdb water.pdb



## select theophylline
set tep [atomselect $tep_mol "resname TEP"]

## select atoms form tep for fitting
set tep_fit [atomselect $tep_mol "resname TEP and name C8 N7 N1 N3"]

## load xanthine
set anl_mol [mol new xanthine.pdb]
set anl [atomselect $anl_mol "all"]

## select atoms from met for fitting
set anl_fit [atomselect $anl_mol "name C5 N2 N3 N1"]


$anl move [measure fit $anl_fit $tep_fit order {1 2 0 3}]

## change ligand's resname to SML for consistency 
$anl set resname SML

$anl writepdb lig.pdb

exit
