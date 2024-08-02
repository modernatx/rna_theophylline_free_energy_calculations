mol new ../1-sys_prep/box.prmtop type parm7
mol addfile equ_2/equ.0.restart.coor type namdbin




exec mkdir -p ini

set sel [atomselect top all]

package require pbctools
pbc readxst equ_2/equ.0.restart.xsc

pbc wrap -center com -centersel nucleic -compound resid
pbc join fragment -sel "resname SML"

$sel frame last
$sel writepdb ini/eq.pdb
$sel writepsf ini/eq.psf

exit
