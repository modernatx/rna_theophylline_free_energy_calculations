# proc align {sel_text} {
#     ## get number of frames
#     set num_fr [molinfo top get numframes]

#     set ref [atomselect top $sel_text frame 0]
#     set sel [atomselect top $sel_text]
#     set all [atomselect top all]

#     for { set i 1 } { $i < $num_fr } { incr i } {
#     $sel frame $i
#     $all frame $i
#     $all move [measure fit $sel $ref]
#     }
# }


package require pbctools
mol load psf ../1-sys_prep/box.psf
mol addfile equ_1/equ.0.restart.coor type namdbin
pbc readxst equ_1/equ.0.restart.xsc
set cell [pbc get -now]
set zm [lindex $cell 0 2]
# mol delete all

# mol load psf ../1-sys_prep/box.psf
# mol addfile equ_0/equ.0.restart.coor type namdbin
# mol addfile equ_1/equ.0.restart.coor type namdbin


set s [atomselect top "resname SML"]
$s moveby "0 0 -$zm"

# align "noh nucleic and backbone"
# animate delete beg 0 end 0
exec mkdir -p ini

set sel [atomselect top all]

# pbc readxst equ_1/equ.0.restart.xsc

# pbc join fragment -sel "nucleic"
pbc wrap -center com -centersel nucleic -compound resid
# pbc join fragment -sel "resname SML"
# pbc wrap -center com -centersel "resname SML" -compound resid

$sel frame last
$sel writepdb ini/eq.pdb
$sel writepsf ini/eq.psf

exit
