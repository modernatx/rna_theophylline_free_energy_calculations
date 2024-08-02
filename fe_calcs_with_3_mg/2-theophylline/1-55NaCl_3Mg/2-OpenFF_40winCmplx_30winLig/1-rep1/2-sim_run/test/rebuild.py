# Imports from the Python standard library
from io import StringIO
from typing import Iterable

# Imports from the comp chem ecosystem
import mdtraj
import numpy as np
import openmm
from openff.units import Quantity, unit
from openff.units.openmm import from_openmm
from openmm import unit as openmm_unit
from pdbfixer import PDBFixer

# Imports from the toolkit
# from openff.toolkit import Molecule, Topology
from openff.toolkit.topology import Molecule, Topology
from openff.toolkit.typing.engines.smirnoff import ForceField


ligand_path = "2-theophylline.sdf"

in_prmtop = "../../1-sys_prep/box.prmtop"
in_crd = "../../1-sys_prep/box.inpcrd"
orig_structure = parmed.amber.AmberParm(in_prmtop, in_crd)

pieces = orig_structure.split()
for piece in pieces:
    print(f"There are {len(piece[1])} instance(s) of {piece[0]}")
    
ligand_off_molecule = Molecule(ligand_path)

ligand_off_topology = ligand_off_molecule.to_topology()

force_field = ForceField("openff_unconstrained-2.0.0.offxml")

ligand_system = force_field.create_openmm_system(ligand_off_topology)
new_ligand_structure = parmed.openmm.load_topology(
    ligand_off_topology.to_openmm(),
    ligand_system,
    xyz=pieces[1][0].positions,
)

# # Load a molecule from a SDF file
# ligand = Molecule.from_file(ligand_path)

# fixer = PDBFixer(ligand_path)
# fixer.addSolvent(
#     Vec3(7, 7, 7) * openmm_unit.nanometer, ionicStrength=0.55 * openmm_unit.molar
# )

ligand_off_molecule = Molecule(ligand_path)

ligand_off_topology = ligand_off_molecule.to_topology()