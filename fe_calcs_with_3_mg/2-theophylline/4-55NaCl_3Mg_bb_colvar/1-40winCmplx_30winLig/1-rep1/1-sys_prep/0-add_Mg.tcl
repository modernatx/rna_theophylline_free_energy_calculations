## load in the pdb
mol new ../0-starting_PDB/1o15.pdb
#########################################  First Mg2+  #########################################
## select atoms coordinating the first Mg2+
set sel1 [atomselect top "(resid 22 and name OP1) or (resid 23 and name O5') or (resid 24 and name O3')"]
## calc the center of mass of the coordinating atoms to place the Mg
set cen1 [measure center $sel1]

## select one atom and change its name to Mg and its coor. to cen1
set mg1 [atomselect top "index 1"]
$mg1 set name MG
$mg1 set element MG
$mg1 set chain A
$mg1 set resname MG
$mg1 set {x} [lindex $cen1 0]
$mg1 set {y} [lindex $cen1 1]
$mg1 set {z} [lindex $cen1 2]
$mg1 set beta 0
$mg1 set occupancy 0

$mg1 writepdb mg1.pdb

#########################################  second Mg2+  #########################################
## select atoms coordinating the second Mg2+
set sel1 [atomselect top "(resid 2 and name O6) or (resid 32 and name O4)"]
## calc the center of mass of the coordinating atoms to place the Mg
set cen1 [measure center $sel1]

## select one atom and change its name to Mg and its coor. to cen1
set mg1 [atomselect top "index 1"]
$mg1 set name MG
$mg1 set element MG
$mg1 set chain A
$mg1 set resname MG
$mg1 set {x} [lindex $cen1 0]
$mg1 set {y} [lindex $cen1 1]
$mg1 set {z} [lindex $cen1 2]
$mg1 set beta 0
$mg1 set occupancy 0

$mg1 writepdb mg2.pdb

#########################################  third Mg2+  #########################################
## select atoms coordinating the third Mg2+
set sel1 [atomselect top "(resid 16 and name OP1) or (resid 14 15 and name OP2)"]
## calc the center of mass of the coordinating atoms to place the Mg
set cen1 [measure center $sel1]

## select one atom and change its name to Mg and its coor. to cen1
set mg1 [atomselect top "index 1"]
$mg1 set name MG
$mg1 set element MG
$mg1 set chain A
$mg1 set resname MG
$mg1 set {x} [lindex $cen1 0]
$mg1 set {y} [lindex $cen1 1]
$mg1 set {z} [lindex $cen1 2]
$mg1 set beta 0
$mg1 set occupancy 0

$mg1 writepdb mg3.pdb

exit