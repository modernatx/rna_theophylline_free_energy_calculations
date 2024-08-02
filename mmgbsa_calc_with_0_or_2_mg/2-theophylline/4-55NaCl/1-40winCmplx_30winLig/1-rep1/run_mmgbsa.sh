~/.bashrc
eval "$(conda shell.bash hook)"

cp ../../../../../fe_calcs_with_0_or_2_mg/2-theophylline/4-55NaCl/1-40winCmplx_30winLig/1-rep1/1-sys_prep/box.prmtop .
cp ../../../../../fe_calcs_with_0_or_2_mg/2-theophylline//4-55NaCl/1-40winCmplx_30winLig/1-rep1/2-sim_run/equ_2/equ.0.dcd .

conda activate LOOS

subsetter -C 'resname=="C" || resname=="A" || resname=="G" || resname=="U" || resname=="C3" || resname=="G5"' --reimage aggressive -i 100 equ.0_stride100_loos box.prmtop equ.0.dcd

~/VMD_binary/bin/vmd -dispdev text -e loos_to_vmddcd.tcl

conda activate AmberTools23

cpptraj -p box.prmtop -y equ.0_stride100_loos_centered_vmdout.dcd  -x equ.0_stride100_loos_centered_vmdout.mdcrd
cpptraj -i strip_cpptraj_rna.in
cpptraj -i strip_cpptraj_dry.in
cpptraj -i strip_cpptraj_lig.in


MMPBSA.py -O -i mmgbsa.in -sp box.prmtop -cp dry.box.prmtop -rp rna.box.prmtop -lp lig.box.prmtop -y equ.0_stride100_loos_centered_vmdout.dcd
