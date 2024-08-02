# Conda environment 
# conda create --name ambertools
# conda install -c conda-forge ambertools
# conda list -e > requirements_ambertools.txt
# conda env export > requirements_ambertools.yml
conda activate ambertools


# pre clean-up before packmol - removing hydrogen
# This is necessary else, the tleap would result in FATAL errors
# This is because the H from Maestro is often not recoganized by AMBER
pdb4amber -i rna.pdb -o rna_noH.pdb --nohyd



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
