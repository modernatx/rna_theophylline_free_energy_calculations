#!/usr/bin/env bash

# conda env activation
# Make sure you have LOOS already installed.
#eval "$(conda shell.bash hook)"
conda activate loos
#conda env update -f requirements_conda.yml

# Preprocessing trajectory
# 0. Making a directory for storing preporocessed traj files
# 1. Create a down-sampled trajectory with stride 100 (1 ns/frame): StepWidth * WritingFrequency * strideSteps = 2fs*5000*50 = 1ns.
# 2. Remove waters from the subset traj
mkdir -p ../pre-process
subsetter --verbosity 1 --stride 100 --selection "resname != 'WAT'" ../pre-process/traj_s100_dry ../../1-sys_prep/box.prmtop ../equ_2/equ.0.dcd
subsetter --verbosity 1 --selection '(resname =~ "^[ACGU][35N]?$" && !hydrogen) || resname == "SML"' ../pre-process/traj_s100_dry_noH ../pre-process/traj_s100_dry.pdb ../pre-process/traj_s100_dry.dcd

# 1.
# 2. Trajectory pre-centering on RNA.
# 3. Trajectory post-centering on ligand
subsetter --reimage=aggressive --verbosity 1 --center='resname =~ "^[ACGU][35N]?$"' --postcenter="resname == 'SML'" ../pre-process/traj_s100_dry_noH_centered ../pre-process/traj_s100_dry_noH.pdb ../pre-process/traj_s100_dry_noH.dcd 

# Aligning the traj on RNA selection w/o hydrogen.
aligner --prefix aligned_traj_s100_dry --align 'resname =~ "^[ACGU][35N]?$"' ../pre-process/traj_s100_dry_noH_centered.pdb ../pre-process/traj_s100_dry_noH_centered.dcd

# Add the pre-process directory to .gitignore
echo "pre-process/" >> ../.gitignore
git add ../.gitignore

# Converting loos env to ipython kernal
# conda install ipykernel
# conda install nb_conda_kernels
# python -m ipykernel install --user --name=loos

