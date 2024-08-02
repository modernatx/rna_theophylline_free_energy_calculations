# proc align {sel_ref sel all mol1} {
#     ## get number of frames
#     set num_fr [molinfo $mol1 get numframes]


#     $all move [measure fit $sel $sel_ref]
# }
package require pbctools
set mol1 [mol load psf ../1-sys_prep/box.psf]
mol addfile equ_1/equ.0.restart.coor type namdbin $mol1

pbc readxst equ_1/equ.0.restart.xsc
set cell [pbc get -now]
set xm [lindex $cell 0 0]
set zm [lindex $cell 0 2]

set s [atomselect top "nucleic"]
$s moveby " -$xm 0 0 "

pbc wrap -center com -centersel nucleic -compound residue


# set ref [mol load psf ../1-sys_prep/box.psf]
# mol addfile equ_0/equ.0.restart.coor type namdbin $ref

# set sel_text "noh nucleic and backbone"
# set sel_ref [atomselect $ref $sel_text frame 0]
# set sel [atomselect $mol1 $sel_text] 
# set all [atomselect $mol1 all]

# align $sel_ref $sel $all $mol1

# animate delete beg 0 end 0
exec mkdir -p ini

set sel [atomselect top all]

$sel frame last
$sel writepdb ini/eq.pdb
$sel writepsf ini/eq.psf

exit
