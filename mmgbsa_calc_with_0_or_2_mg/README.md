# MMGBSA calculations

- We performed MM-GBSA calculations for all six ligands and two conditions presented in this manuscript.
- Directory structure for MM-GBSA calculations follows `[ligand]/[condition]/[replicate]/` format. 
- Input files and code for two ligands (theophylline and xanthine) are provided in this repository as examples.
- For each ligand calculations were performed for systems containing two Mg2+ and zero Mg2+ ions in directories labelled `3-55NaCl_Mg/` and `4-55NaCl/` respectively.
- Calculations for each ligand under each condition includes three replicates. Only replicate one is provided in this repository as an example (see `1-rep1/ directory).  
- To run a MMGBSA calculation go to `[ligand]/[condition]/[replicate]/` directory and run `run_mmgbsa.sh` script. All replicates have their own `run_mmgbsa.sh` scripts.
- All the environment variables are saved in `environment.yml` file.
