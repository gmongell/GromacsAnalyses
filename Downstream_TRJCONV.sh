cd /home/gmongell/

module load gromacs

for l in EtOHMix50 EtOHMix00 EtOHMix70 EtOHMix100 EtOHMix80
do

cd /fs/lustre/cwr0408/$l

for dir in */

do
cd /fs/lustre/cwr0408/$l/$dir

echo 0 | trjconv -f md_concat.trr -s $l\_$dir\_EM.gro -o md_out.gro
echo $dir | ./AnalyzeGro4

done
done
