#The purpose of this script is to convert trajectories and then calculate the densities of various components


module load gromacs/4.6.35
cd /fs/lustre/cwr0408/
for l in EtOHMix50 EtOHMix00 EtOHMix70 EtOHMix100 EtOHMix80
do
cd /fs/lustre/cwr0408/$l
for dir in */
do
cd /fs/lustre/cwr0408/$l/$dir
echo
echo -e "0\n1000\n9000\n" | trjcat -settime -f firstmd.trr secondmd.trr thirdmd.trr -o md_concat.trr
echo 0 | trjconv -f md_concat.trr -s $l\_${dir%?}\_EM.gro -o md_out.gro
echo $dir | ./AnalyzeGro4
echo -e "1" | g_density -f md_concat.trr -s md1.tpr -o $l\_${dir%?}\_density_${i%?}\.xvg -dens mass -d Z
echo -e "6" | g_density -f md_concat.trr -s md1.tpr -o $l\_${dir%?}\_density_EtOH.xvg -dens mass -d Z
echo -e "5" | g_density -f md_concat.trr -s md1.tpr -o $l\_${dir%?}\_density_HOH.xvg -dens mass -d Z
echo -e "0" | g_density -f md_concat.trr -s md1.tpr -o $l\_${dir%?}\_density_Sys.xvg -dens mass -d Z
done
done