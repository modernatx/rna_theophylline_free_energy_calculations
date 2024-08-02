# Conda environment for OpenBabel
conda activate base
conda list -e > requirements_base.txt
conda env export > requirements_base.yml
    
sed -i 's/PAR/SML/' ####-lig1_H.pdb # For Linux, Schrodinger LigPrep

# Antechamber
antechamber -i ####-lig1_H.pdb -fi pdb -o ####.gaff2.mol2 -fo mol2 -c bcc -s 2 -nc NETCHARGE

# Sanity check for antechamber errors.
# There might be other error clues. This method isn't fail safe.
sqm_result=$(grep "Calculation Completed" sqm.out)
# As long as the grep results are empty
if [ -z "$sqm_result" ]
then
	echo -e "\e[32mAntechamber looks successful. Still, act cautious. \e[39m"
else
	echo -e "\e[31mCaught an error in Antechamber. \e[39m"
fi

parmchk2 -i ####.gaff2.mol2 -f mol2 -o ####.gaff2.frcmod -s 2
cp sqm.pdb ####_sqm.pdb

# Create simulation box with Packmol
python create_box_with_packmol.py

# Manually edit the first three residues coresponding to P, OP1, OP2
# Else, this will lead to a FATAL error in tleap step
cp -pf box.pdb box.pdb.BAK
sed -i '/ATOM      1  P/d' box.pdb
sed -i '/ATOM      2  OP1/d' box.pdb
sed -i '/ATOM      3  OP2/d' box.pdb

# Fix the edited .pdb file
pdb4amber -i box.pdb -o box_fixed.pdb

# Remove previous tleap.out file
rm -f tleaps.out

# GenerateAmber coordinate, topology and parameter files. 
tleap -f tleap.in >> tleap.out 2>&1

# Check tleap errors.
# There might be other error clues. This method isn't fail safe.
tleap_result=$(grep "usage" tleap.out || grep -i "error" tleap.out)
# As long as the grep results are empty
if [ -z "$tleap_result" ]
then
	echo -e "\e[32mTleap looks successful. Still, act cautious. \e[39m"
else
	echo -e "\e[31mCaught an error in Tleap. \e[39m"
	echo $tleap_result
fi
