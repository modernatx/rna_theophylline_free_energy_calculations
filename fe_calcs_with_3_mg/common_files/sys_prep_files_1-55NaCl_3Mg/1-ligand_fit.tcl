#################################################
## User needs to open the pdb file and identify
## a few atoms from theophylline and its analog
## to fit them on top of eachother
#################################################



## load in the pdb containg TEP
mol new ../0-starting_PDB/1o15.pdb

## selecting different parts of pdb
set nuc [atomselect top "nucleic"]
set water [atomselect top "water"]


## write out the separate pdb files
$nuc writepdb rna.pdb
$water writepdb water.pdb



## select theophylline
set tep [atomselect top "resname TEP"]
## select atoms form tep for fitting
set tep_fit [atomselect top "resname TEP and name C8 N1 O6 O2"]

## load 1-methylxanthine
mol new 1_methylxanthine.pdb
set met [atomselect top "all"]
## select atoms from met for fitting
set met_fit [atomselect top "name C6 N1 O1 O2"]
$met move [measure fit $met_fit $tep_fit]

## change ligand's resname to SML for consistency 
$met set resname SML

$met writepdb lig.pdb

exit