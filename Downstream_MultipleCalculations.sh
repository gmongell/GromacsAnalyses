#!/bin/sh -l

#Alcohol name variable
X=Et
echo "$XOH"
#Alcohol content variable
C=80
echo "$C%"
#Core Folder
Fold=/fs/lustre/cwr0408/1.29.2014/
echo "$Fold"
#load the gromacs modules
module load gromacs/4.6.3

#looping through the PE and PP systems
for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18
do 
cd /fs/lustre/cwr0408/1.29.2014/
#a place to put all of the derived outputs
mkdir ./outputs
cd /fs/lustre/cwr0408/1.29.2014/$i
#need to correct PE4 to have 3 pbs scripts
echo -e "0\n1000\n9000\n" | trjcat -settime -f firstmd.trr secondmd.trr thirdmd.trr -o md_concat.trr
echo 0 | trjconv -f md_concat.trr -s $XOHMix$C_$i_EM.gro -o md_out.gro
echo $i | ./AnalyzeGro4
#making the ndx file for hoh ordering (only includes waters)
echo -e "name Water\nq" | make_ndx -f md_out.gro -o index.ndx
#making the gro file for the calculation of the order parameter
#echo 1 | trjconv -f md_concat.trr -s EtOHMix80_PP18_EM.gro -o md_out_order.gro
#may need to create a special gro file with only water molecules (ndx required)
#echo 1 | g_order -f md_out_order.gro -s md1.tpr -o order.xvg

#multiple rdf and density calls should be performed ( density for each species [3] and mixture; rdf for each solvent [2])
#computing the rdf of the polymer with water, then alcohol (no ndx needed)
echo -e "6\n1" | g_rdf -f md_concat.trr -s md1.tpr -o $XOH$C_$i_rdf_HOH.xvg -com
echo -e "6\n5" | g_rdf -f md_concat.trr -s md1.tpr -o $XOH$C_$i_rdf_$COH.xvg -com
echo -e "1" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_$i.xvg -dens mass -symm -d Z
echo -e "6" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_$COH.xvg -dens mass -symm -d Z
echo -e "5" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_HOH.xvg -dens mass -symm -d Z
echo -e "0" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_Sys.xvg -dens mass -symm -d Z
#still need to plot and derive kD, althogh it is given as a runtime output in the log
#no ndx required for msd computations
echo 6 | g_msd -f md_concat.trr -s md1.tpr -o msd.xvg
echo 6 | g_gyrate -f md_concat.trr -s md1.tpr -o $XOC$C_$i_gyrate.xvg
#since the .edr files are not concatenatable, this is performed in three steps
#for plotting together in excel
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f firstmd.edr -s md1.tpr -o $XOH$C_$i_energy1.xvg
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f secondmd.edr -s md2.tpr -o $XOH$C_$i_energy2.xvg
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f thirdmd.edr -s md3.tpr -o $XOH$C_$i_energy3.xvg

#copying the outputs to the output folder
cp $XOH$C_$i_rdf_HOH.xvg $XOH$C_$i_rdf_$COH.xvg $XOH$C_$i_density_$i.xvg $XOH$C_$i_density_$COH.xvg /$Fold/outputs
cp $XOH$C_$i_density_HOH.xvg $XOH$C_$i_density_Sys.xvg msd.xvg $XOC$C_$i_gyrate.xvg $XOH$C_$i_energy1.xvg /$Fold/outputs
cp $XOH$C_$i_energy3.xvg $XOH$C_$i_energy3.xvg /$Fold/outputs
cp r_concat.dat /$Fold/outputs/$XOH$C_$i_r.dat
done

#looping through the PIB systems. This sections need to be separate because the resnames do not include the 
#number of carbons as is the case in PP and PE systems
for i in PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/1.29.2014/$i
#add an if loop so that when $i is PIB 24 $j is 24, and so on. j needs to go into AnalyzeGro
echo $i | ./AnalyzeGro4
echo 0\n 1000\n 9000\n | trjcat -settime -f firstmd.trr secondmd.trr thirdmd.trr -o md_concat.trr
echo 0 | trjconv -f md_concat.trr -s $XOHMix$C_$i_EM.gro -o md_out.gro
echo $i | ./AnalyzeGro4 
echo 1 | g_h20order -f md_out.gro -s md1.tpr -o order.xvg 

#echo 1 | g_order -f md_out_order.gro -s md1.tpr -o order.xvg

#multiple rdf and density calls should be performed ( density for each species [3] and mixture; rdf for each solvent [2])
#computing the rdf of the polymer with water, then alcohol (no ndx needed)
echo -e "6\n1" | g_rdf -f md_concat.trr -s md1.tpr -o $XOH$C_$i_rdf_HOH.xvg -com
echo -e "6\n5" | g_rdf -f md_concat.trr -s md1.tpr -o $XOH$C_$i_rdf_$COH.xvg -com
echo -e "1" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_$i.xvg -dens mass -symm -d Z
echo -e "6" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_$COH.xvg -dens mass -symm -d Z
echo -e "5" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_HOH.xvg -dens mass -symm -d Z
echo -e "0" | g_density -f md_concat.trr -s md1.tpr -o $XOH$C_$i_density_Sys.xvg -dens mass -symm -d Z
#still need to plot and derive kD, althogh it is given as a runtime output in the log
#no ndx required for msd computations
echo 6 | g_msd -f md_concat.trr -s md1.tpr -o msd.xvg
echo 6 | g_gyrate -f md_concat.trr -s md1.tpr -o $XOC$C_$i_gyrate.xvg
#since the .edr files are not concatenatable, this is performed in three steps
#for plotting together in excel
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f firstmd.edr -s md1.tpr -o $XOH$C_$i_energy1.xvg
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f secondmd.edr -s md2.tpr -o $XOH$C_$i_energy2.xvg
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f thirdmd.edr -s md3.tpr -o $XOH$C_$i_energy3.xvg

#copying the outputs to the output folder
cp $XOH$C_$i_rdf_HOH.xvg $XOH$C_$i_rdf_$COH.xvg $XOH$C_$i_density_$i.xvg $XOH$C_$i_density_$COH.xvg /$Fold/outputs
cp $XOH$C_$i_density_HOH.xvg $XOH$C_$i_density_Sys.xvg msd.xvg $XOC$C_$i_gyrate.xvg $XOH$C_$i_energy1.xvg /$Fold/outputs
cp $XOH$C_$i_energy3.xvg $XOH$C_$i_energy3.xvg /$Fold/outputs
cp r_concat.dat /$Fold/outputs/$XOH$C_$i_r.dat
done