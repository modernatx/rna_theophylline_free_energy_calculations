mol load psf ../1-sys_prep/box.psf
mol addfile equ_1/equ.0.restart.coor type namdbin

exec mkdir -p ini

set sel [atomselect top all]

package require pbctools
pbc readxst equ_1/equ.0.restart.xsc

pbc wrap -center com -centersel nucleic -compound resid

$sel writepdb ini/eq.pdb
$sel writepsf ini/eq.psf

exit
