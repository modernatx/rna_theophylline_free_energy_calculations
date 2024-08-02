mol new ../1-sys_prep/box.prmtop type parm7
mol addfile equ_1/equ.0.restart.coor type namdbin




exec mkdir -p ini

set sel [atomselect top all]

package require pbctools
pbc readxst equ_1/equ.0.restart.xsc

pbc wrap -center com -centersel nucleic -compound resid
#pbc join fragment -sel "resname SML"

$sel moveby [vecinvert [measure center [atomselect top nucleic] weight mass]]

$sel frame last
$sel writepdb ini/eq.pdb
$sel writepsf ini/eq.psf
$sel writenamdbin ini/eq.coor
exit
