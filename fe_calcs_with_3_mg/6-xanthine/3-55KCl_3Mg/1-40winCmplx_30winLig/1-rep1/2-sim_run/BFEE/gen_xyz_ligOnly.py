import os
import shutil
import subprocess
import sys

import numpy as np

from BFEE2.commonTools import fileParser

selectionLig = "resname SML"

fParserLigandOnly = fileParser.fileParser( f'ligandOnly.pdb')
fParserLigandOnly.saveFile('all', f'ligandOnly.xyz', 'xyz')



fParserLigandOnly.setBeta('all', 0)
fParserLigandOnly.setBeta(selectionLig, 1)

fParserLigandOnly.saveFile('all', f'fep_ligandOnly.pdb', 'pdb')