exec mkdir parsefep
cd parsefep
package require parsefep
parsefep -forward ../fep_forward.fepout -backward ../fep_backward.fepout -bar
exit
