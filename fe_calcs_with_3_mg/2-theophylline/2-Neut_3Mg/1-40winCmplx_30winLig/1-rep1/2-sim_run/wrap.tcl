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

mol load psf ../1-sys_prep/box.psf
# mol addfile equ_0/equ.0.restart.coor type namdbin
mol addfile equ_2/equ.0.restart.coor type namdbin



# align "noh nucleic and backbone"
# animate delete beg 0 end 0
exec mkdir -p ini

set sel [atomselect top all]

package require pbctools
pbc readxst equ_2/equ.0.restart.xsc

pbc wrap -center com -centersel nucleic -compound resid
# pbc join fragment -sel "nucleic"
pbc join fragment -sel "resname SML"
# pbc wrap -center com -centersel "resname SML" -compound resid

$sel frame last
$sel writepdb ini/eq.pdb
$sel writepsf ini/eq.psf

exit
