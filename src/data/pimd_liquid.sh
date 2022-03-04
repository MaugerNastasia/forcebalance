#!/bin/bash
if [ -z "$1" ]; then 
   read -p "Number of beads" beads
else
   beads=$1
fi

rm *_all_beads.out
#Array for Total system Mass
for ((i=1;i<=beads;i++))
do
  if ((i<=9))
  then
    mv liquid_beads00$i.arc liquid-md_beads00$i.arc
    /home/mauger/ForceBalance/ForceBalance_exec/analyze_ponder liquid-md_beads00$i.arc -k liquid-md.key G > G_beads00$i.out
    grep 'Total System Mass' G_beads00$i.out > Total_system_Mass_beads00$i.out
  fi
  if ((i>= 10))
  then
    mv liquid_beads0$i.arc liquid-md_beads0$i.arc
    /home/mauger/ForceBalance/ForceBalance_exec/analyze_ponder liquid-md_beads0$i.arc -k liquid-md.key G > G_beads0$i.out
    grep 'Total System Mass' G_beads0$i.out > Total_system_Mass_beads0$i.out
  fi
done

count_lines=$(cat Total_system_Mass_beads001.out | wc -l)

for((j=1;j<=count_lines;j++))
do
  for ((i=1;i<=beads;i++))
  do
    if ((i<=9))
    then
      sed -n "$j"p Total_system_Mass_beads00$i.out >> test_lines$j.out
    fi
    if ((i>= 10))
    then
      sed -n "$j"p Total_system_Mass_beads0$i.out >> test_lines$j.out
    fi
  done
done

for((j=1;j<=count_lines;j++))
do
      awk '{sum+=$4}END {print sum/NR}' test_lines$j.out >> Total_System_Mass_all_beads.out
done

rm test_lines*
rm Total_sys*


####ANALYZE E#####
for ((i=1;i<=beads;i++))
do
  if ((i<=9))
  then
    mpirun -np 1 /home/mauger/ForceBalance/ForceBalance_exec/analyze liquid-md_beads00$i.arc -k liquid-md.key E > E_beads00$i.out
    grep 'Total Potential Energy' E_beads00$i.out > Total_potential_energy_beads00$i.out
    grep 'Bond Stretching' E_beads00$i.out > Bond_streching2.out
    sed /Individual/d Bond_streching2.out > Bond_streching_beads00$i.out
    rm Bond_streching2.out
    grep 'Angle Bending' E_beads00$i.out > Angle_bending2.out
    sed /Individual/d Angle_bending2.out > Angle_bending_beads00$i.out
    rm Angle_bending2.out
    grep 'Van der Waals' E_beads00$i.out > Van_der_Waals_beads00$i.out
    grep 'Atomic Multipoles' E_beads00$i.out > Atomic_multipoles_beads00$i.out
    grep 'Polarization' E_beads00$i.out > Polarization_beads00$i.out
    grep 'Urey-Bradley' E_beads00$i.out > Urey-Bradley_beads00$i.out
  fi
  if ((i>=10))
  then
    mpirun -np 1 /home/mauger/ForceBalance/ForceBalance_exec/analyze liquid-md_beads0$i.arc -k liquid-md.key E > E_beads0$i.out
    grep 'Total Potential Energy' E_beads0$i.out > Total_potential_energy_beads0$i.out
    grep 'Bond Stretching' E_beads0$i.out > Bond_streching2.out
    sed /Individual/d Bond_streching2.out > Bond_streching_beads0$i.out
    rm Bond_streching2.out
    grep 'Angle Bending' E_beads0$i.out > Angle_bending2.out
    sed /Individual/d Angle_bending2.out > Angle_bending_beads0$i.out
    rm Angle_bending2.out
    grep 'Van der Waals' E_beads0$i.out > Van_der_Waals_beads0$i.out
    grep 'Atomic Multipoles' E_beads0$i.out > Atomic_multipoles_beads0$i.out
    grep 'Polarization' E_beads0$i.out > Polarization_beads0$i.out
    grep 'Urey-Bradley' E_beads0$i.out > Urey-Bradley_beads0$i.out
  fi
done

#Array for potential Energy
count_lines=$(cat Total_potential_energy_beads001.out | wc -l)

for((j=1;j<=count_lines;j++))
do
  for((i=1;i<=beads;i++))
  do
    if ((i<=9))
    then
      sed -n "$j"p Total_potential_energy_beads00$i.out >> test_lines$j.out
    fi
    if ((i>=10))
    then
      sed -n "$j"p Total_potential_energy_beads0$i.out >> test_lines$j.out
    fi
  done
done

for((j=1;j<=count_lines;j++))
do
      awk '{sum+=$5}END {print sum/NR}' test_lines$j.out >> Total_potential_Energy_bad_units.out
      awk '{print $1*4.184}' Total_potential_Energy_bad_units.out > Total_Potential_Energy_all_beads.out
done

rm Total_poten*

#Array for others energies
count_lines=$(cat Polarization_beads001.out |wc -l)

for((j=1;j<=count_lines;j++))
do
  for((i=1;i<=beads;i++))
    do
      if ((i<=9))
      then
        sed -n "$j"p Bond_streching_beads00$i.out >> test_lines_bond$j.out
        sed -n "$j"p Angle_bending_beads00$i.out >> test_lines_angle$j.out
        sed -n "$j"p Van_der_Waals_beads00$i.out >> test_lines_vdw$j.out
        sed -n "$j"p Atomic_multipoles_beads00$i.out >> test_lines_multipoles$j.out
        sed -n "$j"p Polarization_beads00$i.out >> test_lines_polarization$j.out
        sed -n "$j"p Urey-Bradley_beads00$i.out >> test_lines_urey$j.out
      fi
      if ((i>=10))
      then
        sed -n "$j"p Bond_streching_beads0$i.out >> test_lines_bond$j.out
        sed -n "$j"p Angle_bending_beads0$i.out >> test_lines_angle$j.out
        sed -n "$j"p Van_der_Waals_beads0$i.out >> test_lines_vdw$j.out
        sed -n "$j"p Atomic_multipoles_beads0$i.out >> test_lines_multipoles$j.out
        sed -n "$j"p Polarization_beads0$i.out >> test_lines_polarization$j.out
        sed -n "$j"p Urey-Bradley_beads0$i.out >> test_lines_urey$j.out
      fi
    done
done

for((j=1;j<=count_lines;j++))
do
      awk '{sum+=$3}END {print sum/NR}' test_lines_bond$j.out >> Bond_Streching_all_beads_bad_units.out
      awk '{sum+=$3}END {print sum/NR}' test_lines_angle$j.out >> Angle_Bending_all_beads_bad_units.out
      awk '{sum+=$4}END {print sum/NR}' test_lines_vdw$j.out >> VdW_all_beads_bad_units.out
      awk '{sum+=$3}END {print sum/NR}' test_lines_multipoles$j.out >> Atomic_multipoles_all_beads_bad_units.out
      awk '{sum+=$2}END {print sum/NR}' test_lines_polarization$j.out >> Polarization_all_beads_bad_units.out
      awk '{sum+=$2}END {print sum/NR}' test_lines_urey$j.out >> Urey-Bradley_all_beads_bad_units.out
      
      awk '{print $1*4.184}' Bond_Streching_all_beads_bad_units.out > Bond_Streching_all_beads.out
      awk '{print $1*4.184}' Angle_Bending_all_beads_bad_units.out > Angle_Bending_all_beads.out
      awk '{print $1*4.184}' VdW_all_beads_bad_units.out > VdW_all_beads.out
      awk '{print $1*4.184}' Atomic_multipoles_all_beads_bad_units.out > Atomic_Multipoles_all_beads.out
      awk '{print $1*4.184}' Polarization_all_beads_bad_units.out > Polarization_all_beads.out
      awk '{print $1*4.184}' Urey-Bradley_all_beads_bad_units.out > Urey-Bradley_all_beads.out
done
 
rm test_lines*
rm *bad_units.out




#Array for the dipoles
for ((i=1;i<=beads;i++))
do
  if ((i<=9))
  then
    mpirun -np 1 /home/mauger/ForceBalance/ForceBalance_exec/analyze liquid-md_beads00$i.arc -k liquid-md.key D > D_beads00$i.out
    grep 'Dipole X,Y,Z' D_beads00$i.out > Dipole_components_beads00$i.out
  fi
  if ((i>=10))
  then
    mpirun -np 1 /home/mauger/ForceBalance/ForceBalance_exec/analyze liquid-md_beads0$i.arc -k liquid-md.key D > D_beads0$i.out
    grep 'Dipole X,Y,Z' D_beads0$i.out > Dipole_components_beads0$i.out
  fi
done

count_lines=$(cat Dipole_components_beads001.out | wc -l)

for((j=1;j<=count_lines;j++))
do
  for((i=1;i<=beads;i++))
  do
    if ((i<=9))
    then
      sed -n "$j"p Dipole_components_beads00$i.out >> test_lines$j.out
    fi
    if ((i>=10))
    then
      sed -n "$j"p Dipole_components_beads0$i.out >> test_lines$j.out
    fi
  done
done

for((j=1;j<=count_lines;j++))
do
      awk '{sum+=$4}END {print sum/NR}' test_lines$j.out >> colonne4.out
      awk '{sum+=$5}END {print sum/NR}' test_lines$j.out >> colonne5.out
      awk '{sum+=$6}END {print sum/NR}' test_lines$j.out >> colonne6.out
done

paste colonne4.out colonne5.out colonne6.out > Dipole_Components_all_beads.out

rm test_lines*
rm Dipole_comp*
rm colonne*




