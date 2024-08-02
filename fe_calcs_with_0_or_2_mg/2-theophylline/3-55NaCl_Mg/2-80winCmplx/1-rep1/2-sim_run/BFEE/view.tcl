#This file contains viewpoints for the VMD viewchangerender plugin.
#Type 'source /Users/arasouli/Desktop/ins1/repos/alchemical/rna_small_molecule_FE/2-theophylline/3-55NaCl_Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/BFEE/view.tcl' from the VMD command window to load these viewpoints.

proc viewchangerender_restore_my_state {} {
  variable ::VCR::viewpoints

  set ::VCR::viewpoints(1,3) { {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} }
  set ::VCR::viewpoints(2,2) { {{0.027349 0 0 0} {0 0.027349 0 0} {0 0 0.027349 0} {0 0 0 1}} }
  set ::VCR::viewpoints(3,1) { {{1 0 0 0.0653978} {0 1 0 0.0968161} {0 0 1 -0.0979861} {0 0 0 1}} }
  set ::VCR::viewpoints(3,2) { {{0.027349 0 0 0} {0 0.027349 0 0} {0 0 0.027349 0} {0 0 0 1}} }
  set ::VCR::viewpoints(1,4) { 1 }
  set ::VCR::viewpoints(2,3) { {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} }
  set ::VCR::viewpoints(3,3) { {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} }
  set ::VCR::viewpoints(2,4) { 1 }
  set ::VCR::viewpoints(3,4) { 81 }
  set ::VCR::viewpoints(1,0) { {{0.0170462 -0.107579 -0.994031 0} {-0.995575 -0.0935597 -0.00694974 0} {-0.0922559 0.989766 -0.108701 0} {0 0 0 1}} }
  set ::VCR::viewpoints(1,1) { {{1 0 0 0.0653978} {0 1 0 0.0968161} {0 0 1 -0.0979861} {0 0 0 1}} }
  set ::VCR::viewpoints(2,0) { {{0.0260164 0.999592 0.00986937 0} {-0.998921 0.0263719 -0.0378127 0} {-0.0380558 -0.00887589 0.999215 0} {0 0 0 1}} }
  set ::VCR::viewpoints(1,2) { {{0.027349 0 0 0} {0 0.027349 0 0} {0 0 0.027349 0} {0 0 0 1}} }
  set ::VCR::viewpoints(2,1) { {{1 0 0 0.0653978} {0 1 0 0.0968161} {0 0 1 -0.0979861} {0 0 0 1}} }
  set ::VCR::viewpoints(3,0) { {{0.0260164 0.999592 0.00986937 0} {-0.998921 0.0263719 -0.0378127 0} {-0.0380558 -0.00887589 0.999215 0} {0 0 0 1}} }
  set ::VCR::representations(1,box.psf) [list NewRibbons_0.470000_22.000000_3.000000_0-nucleic_and_backbone-ColorID_3-AOChalky Licorice_0.2_20_20-noh_nucleic_and_not_backbone_or_(name_C4'_C3')-ResName-AOChalky VDW_1.100000_20.000000-resname_SML-Name-AOChalky VDW_0.600000_20.000000-name_MG-ColorID_29-AOChalky QuickSurf_2.400000_0.100000_1.000000_1.000000-water-ColorID_6-trans3 ]
  set ::VCR::representations(2,box.psf) [list NewRibbons_0.470000_22.000000_3.000000_0-nucleic_and_backbone-ColorID_3-AOChalky Licorice_0.2_20_20-noh_nucleic_and_not_backbone_or_(name_C4'_C3')-ResName-AOChalky VDW_1.100000_20.000000-resname_SML-Name-AOChalky VDW_0.600000_20.000000-name_MG-ColorID_29-AOChalky QuickSurf_2.400000_0.100000_1.000000_1.000000-water-ColorID_6-trans3 ]
  set ::VCR::representations(3,box.psf) [list NewRibbons_0.470000_22.000000_3.000000_0-nucleic_and_backbone-ColorID_3-AOChalky Licorice_0.2_20_20-noh_nucleic_and_not_backbone_or_(name_C4'_C3')-ResName-AOChalky VDW_1.100000_20.000000-resname_SML-Name-AOChalky VDW_0.600000_20.000000-name_MG-ColorID_29-AOChalky QuickSurf_2.400000_0.100000_1.000000_1.000000-water-ColorID_6-trans3 ]
  set ::VCR::movieList ""
  set ::VCR::movieTimeList ""
  set ::VCR::movieTime 0.0
  set ::VCR::movieDuration 0.00  
  ::VCR::calctimescale 0
  global PrevScreenSize
  set PrevScreenSize [display get size]
  proc RestoreScreenSize {} { global PrevScreenSize; display resize [lindex $PrevScreenSize 0] [lindex $PrevScreenSize 1] }
  display resize 1200 1200
  if { [parallel noderank] == 0 } {
    puts "Loaded viewchangerender viewpoints file /Users/arasouli/Desktop/ins1/repos/alchemical/rna_small_molecule_FE/2-theophylline/3-55NaCl_Mg/1-40winCmplx_30winLig/1-rep1/2-sim_run/BFEE/view.tcl "
    puts "Note: The screen size has been changed to that stored in the viewpoints file."
    puts "To restore it to its previous size type this into the Tcl console:\n  RestoreScreenSize"
  }
  return
}


viewchangerender_restore_my_state


