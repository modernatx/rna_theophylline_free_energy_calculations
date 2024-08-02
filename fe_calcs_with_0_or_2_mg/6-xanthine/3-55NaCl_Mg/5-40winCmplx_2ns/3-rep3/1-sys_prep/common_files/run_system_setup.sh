# Conda environment for OpenBabel
conda activate base
conda list -e > requirements_base.txt
conda env export > requirements_base.yml
    
# Minor clean-up : Making ligand resname consistent across different systems
sed -i 's/XXXXXX/SML/' ####-lig1_H.pdb

# Antechamber deployment
antechamber -i ####-lig1_H.pdb -fi pdb -o ####.gaff2.mol2 -fo mol2 -c bcc -s 2 -nc NETCHARGE

# Sanity check for antechamber errors.
# There might be other error clues. This method isn't fail safe.
# As long as the grep results are empty
sqm_result=$(grep "Calculation Completed" sqm.out)
if [ -v sqm_result ]
then
	echo -e "\e[32mAntechamber looks successful. Still, act cautious. \e[39m"
else
	echo -e "\e[31mCaught an error in Antechamber. \e[39m"
fi

# Parameter check and renaming of output
parmchk2 -i ####.gaff2.mol2 -f mol2 -o ####.gaff2.frcmod -s 2
cp sqm.pdb ####_sqm.pdb

# pre clean-up before packmol - removing hydrogen
# This is necessary else, the tleap would result in FATAL errors
# This is because the H from Maestro is often not recoganized by AMBER
pdb4amber -i ####-rna.pdb -o ####-rna_noH.pdb --nohyd

#------------------------------------------------------------------------------#
# Major clean-up to avoid tleap failure if necessary
# Find the chains 5' end with extra PO3 and remove them
# Example cases : 1J7T, 1LC4
# Else, this will lead to a FATAL error in tleap step
# NOTE : The DELETED ARRAY CAN BE EXTENDED TO MEET FUTURE NEEDS

cp -pf ####-rna_noH.pdb ####-rna_noH.pdb.BAK

NEEDFIX=0
value="P"
value1="OP1"
value2="OP2"

## Find the lines for first chain 5' end with extra PO3 and remove them
DELETED=("ATOM      1  ${value}"
	 "ATOM      2  ${value1}"
	 "ATOM      3  ${value2}"
	)

for delete in "${DELETED[@]}" ; do
	if grep -q "$delete" ####-rna_noH.pdb
	then
		echo "Caution !! ${delete} is removed"
		sed -i "/$delete/d" ####-rna_noH.pdb
		NEEDFIX=1
	fi
done

## Find the lines for second chain 5' end with extra PO3 and remove them, if present
# checking if the PDB has multiple TERs
if grep -q "TER" ####-rna_noH.pdb.BAK | head -n 2
then
	# Greping Next three lines after the first TER into an array
	mapfile -t OTHERprimePO < <( grep -A 3 "TER" ####-rna_noH.pdb.BAK | head -n 4 | tail -n 3 )
	# Checking if the array has P, OP1, OP2, if yes, delete the lines
	if [[ " ${OTHERprimePO[*]} " =~ " ${value0} " ]] && [[ " ${OTHERprimePO[*]} " =~ " ${value1} " ]] && [[ " ${OTHERprimePO[*]} " =~ " ${value2} " ]]; then
		for other in "${OTHERprimePO[@]}" ; do
			if grep -q "$other" ####-rna_noH.pdb
			then
				echo "Caution !! ${other} is removed"
				sed -i "/$other/d" ####-rna_noH.pdb
				# Raise the need fix flag for pdb4Amber
				NEEDFIX=1
			fi
		done
	fi
fi

# Fixing the PDB due to broken res info
if [[ $NEEDFIX == 1 ]]
then
	pdb4amber -i ####-rna_noH.pdb -o ####-rna_noH_fixed.pdb
else
	cp -pf ####-rna_noH.pdb ####-rna_noH_fixed.pdb
fi

#------------------------------------------------------------------------------#

# Remove previous tleap.out file
rm -f tleap.out

# GenerateAmber coordinate, topology and parameter files. 
tleap -f tleap.in >> tleap.out 2>&1

# Sanity check tleap errors.
# There might be other error clues. This method isn't fail safe.
# As long as the grep results are empty
tleap_result=$(grep "usage" tleap.out || grep -i "error" tleap.out)
if [ -z "$tleap_result" ]
then
	echo -e "\e[32mTleap looks successful. Still, act cautious. \e[39m"
else
	echo -e "\e[31mCaught an error in Tleap. \e[39m"
	echo $tleap_result
fi
