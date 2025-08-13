

X=Et
C=80
module load gromacs/4.6.3
for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18 PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/1.29.2014/$i
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f firstmd.edr -s md1.tpr -o $X\OH$C\_$i\_energy1.xvg
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f secondmd.edr -s md2.tpr -o $X\OH$C\_$i\_energy2.xvg
echo 2 3 4 5 6 7 8 12 33 34 35 36 23 27 31\n | g_energy -f thirdmd.edr -s md3.tpr -o $X\OH$C\_$i\_energy3.xvg
done