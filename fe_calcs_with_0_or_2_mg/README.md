# Free Energy Calculations with RNA Model with Zero or Two Mg2+ ions

This repository contains equilibration and alchemical free energy calculations of theophylline and its analogues.
For the "1-rna_only" system, only equilibration is done, to check if the RNA undergoes large conformational changes without the bound ligand or not.

### Directoy map ###

```
.
├── 2-theophylline                                      : system directory named by ligands
│   ├── 1-150KCl_Mg                                     : condition director (salt and Mg)
│   │   ├── 1-40winCmplx_30winLig                       : alchemical protocol directory (number of labda windows)       						
│   │   │   ├── 1-rep1					: replica directory
│   │   │   │   └── 0-starting_PDB			: input PDB from RCSB database
│   │   │   │   └── 1-sys_prep  			: system preparation files
│   │   │   │   └── 2-sim_run   			: simulation directory
│   │   │   │   │   └── restraints 			: solute restraints file
│   │   │   │   │   └── equ_0   			: intial minmization and solute restrained simul.
│   │   │   │   │   └── equ_1   			: gradual release of the solute restraints
│   │   │   │   │   └── equ_2   			: unrestrained 100 ns equilibration
│   │   │   │   │   └── ini   				: pdb and psf after 100 ns equilibration to input to BFEE2
│   │   │   │   │   └── BFEE    			: BFEE files for alchemical free enegy calc.
│   │   │   │   │   ├── 001_MoleculeBound		: bound state : Fwd-bwd FEP calcs
│   │   │   │   │   │   └── output
│   │   │   │   │   ├── 002_RestraintBound		: bound state : TI for restraint contributions
│   │   │   │   │   │   └── output
│   │   │   │   │   ├── 003_MoleculeUnbound		: unbound state : fwd-bwd FEP calcs
│   │   │   │   │   │   └── output
│   │   │   │   │   └── 004_RestraintUnbound		: unbound state : TI for restraint contributions
│   │   │   │   │       └── output
│   │   ├── 2-80winCmplx                                : 80 windows for ligand-bound system
│   │   │   ├── 2-rep2					: next replica
.	.	.
│   ├── 2-150KCl                                        : next condition
.	.	.                                   
├── 6-xantine		  				: next system
.	.
.	.	.
.	.	.	.
├── common_files    	    				: common files and scripts templates are kept here
```


### Simulated systems and conditions ##
<!-- 2-theophylline:     Conditions: {1-150KCl_Mg, 2-150KCl, 3-55NaCl_Mg, 4-55NaCl, 5-55NaCl_bb, 6-55NaCl_Mg_bb, 7-55NaCl_Mg_postEq_bb}
                    Replicas:   {1-rep1, 2-rep2, 3-rep3}
3-1_methylxanthine: Conditions: {1-150KCl_Mg}
                    Replicas:   {1-rep1, 2-rep2, 3-rep3}                
4-3_methylxanthine: Conditions: {1-150KCl_Mg}
                    Replicas:   {1-rep1, 2-rep2, 3-rep3} 
5-hypoxanthine:     Conditions: {1-150KCl_Mg}
                    Replicas:   {1-rep1, 2-rep2, 3-rep3}
6-xanthine:         Conditions: {1-150KCl_Mg, 2-150KCl, 3-55NaCl_Mg, 4-55NaCl, 5-55NaCl_bb, 6-55NaCl_Mg_bb, 7-55NaCl_Mg_postEq_bb}
                    Replicas:   {1-rep1, 2-rep2, 3-rep3}
7-caffeine:         Conditions: {1-150KCl_Mg, 2-150KCl, 3-55NaCl_Mg, 4-55NaCl, 5-55NaCl_bb, 6-55NaCl_Mg_bb, 7-55NaCl_Mg_postEq_bb}
                    Replicas:   {1-rep1, 2-rep2, 3-rep3} -->


| System                                                                          | Simulated conditions | # replicas | RNA-ligand system # windows | ligand-only system # windows |
| :----:                                                                          |    :----:            |   :----:   |    :----:                   |    :----:                    |    
|theophylline, xanthine, caffein                                                  | 1-7                  |      3     | 40, even spacing            |  30, even spacing            |
|theophylline, 1_methylxanthine, 3_methylxanthine, hypoxanthine, xanthine, caffein| 1                    |      3     | 80, even spacing            |  N/A                         | 
|theophylline, xanthine, caffein                                                  | 4                    |      3     | 40, uneven spacing          |  N/A                         | 
|1_methylxanthine, 3_methylxanthine, hypoxanthine                                 | 1, 3, 4, 6           |      3     | 40, even spacing            |  30, even spacing            |

### Conditions ##
| Syntax              | Salt condition                | Positional restraints                        |
| :----:              |    :----:                     |    :----:                                    |
| 1-150KCl_Mg         | 150 mM KCl, 2 Mg<sup>2+*</sup>|                     -                        |                                     
| 2-150KCl            | 150 mM KCl                    |                     -                        | 
| 3-55NaCl_Mg         | 55 mM KCl, 2 Mg<sup>2+*</sup> |                     -                        |
| 4-55NaCl            | 55 mM KCl                     |                     -                        |
| 5-55NaCl_bb         | 55 mM KCl                     |RNA backbone, ref: initial pdb positions      |
|6-55NaCl_Mg_bb       | 55 mM KCl, 2 Mg<sup>2+*</sup> |RNA backbone, ref: initial pdb positions      |
|7-55NaCl_Mg_postEq_bb| 55 mM KCl, 2 Mg<sup>2+*</sup> |RNA backbone, ref: last frame of step: 000_eq |

<sup>*</sup>coordinating w/ (residue: 22-24) & (residues: 14-16)

### System set up ###
Neccessary files for initial system prepartion can be found in "1-sys_prep" directory for each system.

For conditions: {1-150KCl_Mg, 3-55NaCl_Mg, 6-55NaCl_Mg_bb, 7-55NaCl_Mg_postEq_bb} we include 2 Mg2+ ions binding to the RNA 
(for other conditions we don't have the "0-add_Mg.tcl" step but the other step are the same):

"0-add_Mg.tcl": Places two Mg2+ on the RNA as described by [Gouda et al.](https://doi.org/10.1002/bip.10270)

`vmd -dispdev text -e 0-add_Mg.tcl`

"1-extract_lig_pdb_resname.tcl": Changes resname of all ligands to "SML" (user needs to set the ligand resname as found in the pdb first).
Also, writes out separate pdb files for RNA and ligand.

`vmd -dispdev text -e 1-extract_lig_pdb_resname.tcl`

"2-run_system_setup.sh": Prepares the pdb and prmtop file using Ambertools. User needs to set the ligand charge in this file.
This file also reads in the "tleap.in" to build the system.

`bash 2-run_system_setup.sh`

"3-gen_psf.py": Generates psf file from pbd and prmtop files. The psf is not used for simulation purposes, but might be useful for visualization using VMD.

`python 3-gen_psf.py`

For the free energy calculations, the last snapshot from the 100 ns unrestrained simulation (equ_2) is first extracted and then RNA is moved to the center 
of the box and water and ions are wrapped around it using "wrap.tcl". There is a bash script, "run_wrap.sh", to run this script
for all systems and replicas, found in the main directory. After running "wrap.tcl", "ini" directory is created in "2-sim_run"
and eq.pdb and eq.psfare genreated in there. We use "eq.pdb" as input for generating free energy calculations using BFEE2.
User must open the eq.pdb and check the structure to avoid ligand being streched across the periodic boundry

After [installing BFEE2](https://github.com/fhh2626/BFEE2#installation), X11 forwarding is used to run `BFEE2Gui.py` on the AWS instance using: `ssh -X USERNAME@Instance IP Address`.

After generating the input file using BFEE2, user needs to run "run_fix_ligOnly.sh", to neutralize the ligandOnly system. 

#### Adding backbone restraints ####
For conditions: {5-55NaCl_bb, 6-55NaCl_Mg_bb, 7-55NaCl_Mg_postEq_bb} we have backbone restraints (2 kcal/mol/A**2)
For conditions: {5-55NaCl_bb, 6-55NaCl_Mg_bb} user needs to first generate systems and after equilibration and
genration of files w/ BFEE, user needs to run: "run_add_bb.sh" to add restraints lines in the config files.

The condition: {7-55NaCl_Mg_postEq_bb}, sets the restraints to the last frame of the "000_eq" equilibration, to compare
with the condition: {3-55NaCl_Mg}, where we don't have the restraints. Hence {7-55NaCl_Mg_postEq_bb} starts the calculations
from after 10 ns equilibration in {3-55NaCl_Mg} and only runs the steps 1 (001_MoleculeBound) and 2 (002_RestraintBound).
To set the restraints user needs to run: "run_add_bb_postEq.sh".

### Running the simulations ###

All simulation files can be found in "2-sim_run" directory for each system.

Initially, system is equilibrated in 3 step: equ_0, equ_1, and equ_3. Before running these simulations, make sure the restraint file
is generated in the "restraints" direcoty by running:

`vmd -dispdev text -e restraints.tcl`

You can run the simulations in equ_0, equ_1, and equ_3, through the "run_1.sh" found in "2-sim_run" directory.
User can use "p3.2xlarge" instance for these equilibration steps.

Free energy calculations are set up using BFEE2 tool:

For the FEP and TI calculations, 40 and 30 windoews are chosen (1-40winCmplx_30winLig), respectively.
For all ligands and for only the condition: {1-150KCl_Mg}, we ran only the ligand-bound system with 80 windows (2-80winCmplx)
User can use "g5.4xlarge" instance for running these calculations.

#### Test parallel running of bwd and fwd ####
To test the effects of running the forward transformation in parllel with the backward, with input from "000_eq/output/eq.restart.*"
instead of the backward's last frame, user can run "run_bkw_frw_test.sh" to make the directries and change the config files.
This test has been currently done for "6-xanthine" and "7-caffein" in two conditions: "4-55NaCl" and "5-55NaCl_bb".
In these tests, only complex (ligand-bound) system is tested for both steps 1 and 2 (001_MoleculeBound and 002_RestraintBound).

### Benchmark ###
For complex (RNA-small molecul) system with 40 windows (1 ns/win):

    1. p3.2xlarge   3 CPUs      ~ 2 days, 15 hr
    2. g5.4xlarge   6 CPUs      ~ 1 day,  7  hr


### Analysis ###
To get the results from BFEE2 use:
`conda activate bfee`
`python post_treatment_pandas_failed_rep.py`

Note: For doubling the sampling with 80 windows, change the following the in the BFEE2 analysis scripts:\\
`vi /opt/install/conda/envs/bfee/lib/python3.11/site-packages/BFEE2/third_party/py_bar.py`\\
go to line 170 and change the following lines:\\
`170         for i in range(len(forward_data[0])):
171             for j in range(len(backward_data[0])):
172                 if forward_data[0][i][0] == backward_data[0][j][1] and \
173                     forward_data[0][i][1] == backward_data[0][j][0]:
174                     merged_data.append((forward_data[1][i], backward_data[1][j]))
175                     break
176             else:
177                 raise RuntimeError('Error! the forward and backward files do not match!')`\\
to this:\\
`170         for i in range(len(forward_data[0])):
171             for j in range(len(backward_data[0])):
172                 if ( forward_data[0][i][0] - backward_data[0][j][1] < 1E-5) and \
173                     ( forward_data[0][i][1] - backward_data[0][j][0]< 1E-5 ):
174                     merged_data.append((forward_data[1][i], backward_data[1][j]))
175                     break
176             else:
177                 raise RuntimeError('Error! the forward and backward files do not match!')`\\

For RMSD backbone restraints analysis do the following change:\\
`vi /opt/install/conda/envs/bfee/lib/python3.11/site-packages/BFEE2/postTreatment.py`\\
Go to line 348:\\
change the following lines:\\
`348         if rigidLigand:
349             numCVs = 6
350         else:
351             numCVs = 7`\\
to:\\
`348         if rigidLigand:
349             numCVs = 6
350         else:
351             numCVs = 8`\\

RMSD analysis steps:
Run `run_analysis.sh` in the main direcotry:
`bash run_analysis.sh`
For plotting each condition in a figure with subplots, run the jupyter notebook `plot_rmsd_subplot.ipynb`, in the main direcotry.


Rgyr analysis steps:
Run `run_rgyr.sh` in the main direcotry:
`bash run_rgyr.sh`
For plotting each condition in a figure with subplots, run the jupyter notebook `plot_rgyr.ipynb`, in the main direcotry.

Ion density analysis steps:
Run `run_ion_density.tcl` in the main direcotry:
`bash run_ion_density.tcl`
Then go to where densities are saved:
`cd results/ion_density_scaled`
and run `avg_density.tcl` to get the average densities:
`vmd -dispdev text -e avg_density.tcl`

RDF analysis steps:
Method 1, using VMD:
`cd analysis/RDF`
Run `VMD_RDF.tcl`
`vmd -dispdev text -e VMD_RDF.tcl`
`cd vmd_rdfs`
For plotting run the jupyter notebook `plot_vmd_rdf.ipynb`, in the main direcotry.

Method 2, using MDanalysis:
Run the jupyter notebook `RDF_InterRDF.ipynb` found in:
`cd analysis/RDF`

KL divergence analysis of the fwd bwd overlaps:
Run `run_parsefep_du_plot.sh` in the main direcotry:
`bash run_parsefep_du_plot.sh`
To plot the the bar plot for each condition with subplots, run the jupyter notebook `plot_kl_hell_subplot.ipynb`, in the main direcotry.

### Conda requirement files ###
You can find the requirement fils in: `results/cond_envs`


### new repo for sytems containg 3 Mg<sup>2+*</sup> ions ###
https://bitbucket.org/modernatx/3_mg_rna_small_molecule_fe/src/master/

### Contributors ###
Co-op: Ali Rasouli (ali.rasouli28@gmail.com)
Managers: Mehtap Isik, Frank Pickard
