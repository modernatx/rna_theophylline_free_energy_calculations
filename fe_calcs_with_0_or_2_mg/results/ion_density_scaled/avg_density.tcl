# voltool add -i1 2-theophylline_1-55NaCl_3Mg.dx -i2 3-1_methylxanthine_1-55NaCl_3Mg.dx -o sum1.dx

# voltool add -i1 sum1.dx -i2 4-3_methylxanthine_1-55NaCl_3Mg.dx -o sum2.dx
# voltool add -i1 sum2.dx -i2 5-hypoxanthine_1-55NaCl_3Mg.dx -o sum3.dx
# voltool add -i1 sum3.dx -i2 6-xanthine_1-55NaCl_3Mg.dx -o sum4.dx
# voltool add -i1 sum4.dx -i2 7-caffeine_1-55NaCl_3Mg.dx -o sum5.dx

# voltool smult -amt 0.16666 -i sum5.dx -o avg_55NaCl_3Mg.dx


# voltool add -i1 2-theophylline_10-55KCl_Mg.dx -i2 3-1_methylxanthine_10-55KCl_Mg.dx -o sum1.dx

# voltool add -i1 sum1.dx -i2 4-3_methylxanthine_10-55KCl_Mg.dx -o sum2.dx
# voltool add -i1 sum2.dx -i2 5-hypoxanthine_10-55KCl_Mg.dx -o sum3.dx
# voltool add -i1 sum3.dx -i2 6-xanthine_10-55KCl_Mg.dx -o sum4.dx
# voltool add -i1 sum4.dx -i2 7-caffeine_10-55KCl_Mg.dx -o sum5.dx

# voltool smult -amt 0.16666 -i sum5.dx -o avg_10-55KCl_Mg.dx

# voltool add -i1 2-theophylline_3-55KCl_3Mg.dx -i2 3-1_methylxanthine_3-55KCl_3Mg.dx -o sum1.dx

# voltool add -i1 sum1.dx -i2 4-3_methylxanthine_3-55KCl_3Mg.dx -o sum2.dx
# voltool add -i1 sum2.dx -i2 5-hypoxanthine_3-55KCl_3Mg.dx -o sum3.dx
# voltool add -i1 sum3.dx -i2 6-xanthine_3-55KCl_3Mg.dx -o sum4.dx
# voltool add -i1 sum4.dx -i2 7-caffeine_3-55KCl_3Mg.dx -o sum5.dx

# voltool smult -amt 0.16666 -i sum5.dx -o avg_3-55KCl_3Mg.dx

# voltool add -i1 2-theophylline_3-55KCl_3Mg.dx -i2 3-1_methylxanthine_3-55NaCl_Mg.dx -o sum1.dx

# voltool add -i1 sum1.dx -i2 4-3_methylxanthine_3-55NaCl_Mg.dx -o sum2.dx
# voltool add -i1 sum2.dx -i2 5-hypoxanthine_3-55NaCl_Mg.dx -o sum3.dx
# voltool add -i1 sum3.dx -i2 6-xanthine_3-55NaCl_Mg.dx -o sum4.dx
# voltool add -i1 sum4.dx -i2 7-caffeine_3-55NaCl_Mg.dx -o sum5.dx

# voltool smult -amt 0.16666 -i sum5.dx -o avg_3-55NaCl_Mg.dx



voltool add -i1 2-theophylline_4-55NaCl.dx -i2 3-1_methylxanthine_4-55NaCl.dx -o sum1.dx

voltool add -i1 sum1.dx -i2 4-3_methylxanthine_4-55NaCl.dx -o sum2.dx
voltool add -i1 sum2.dx -i2 5-hypoxanthine_4-55NaCl.dx -o sum3.dx
voltool add -i1 sum3.dx -i2 6-xanthine_4-55NaCl.dx -o sum4.dx
voltool add -i1 sum4.dx -i2 7-caffeine_4-55NaCl.dx -o sum5.dx

voltool smult -amt 0.16666 -i sum5.dx -o avg_4-55NaCl.dx
exit