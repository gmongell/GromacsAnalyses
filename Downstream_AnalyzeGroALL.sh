#The purpose of this script is to copy of the analysis program results to a single folder with file name 
#changes.

for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18 PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/8.8.2013/$i
echo $i | ./AnalyzeGro4
cp /fs/lustre/cwr0408/8.8.2013/$i/r_concat.dat /fs/lustre/cwr0408/8.8.2013/outputs/r_concat_EtOHMix50_\$i.dat
done

for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18 PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/9.3.2014/$i
echo $i | ./AnalyzeGro4
cp /fs/lustre/cwr0408/9.3.2014/$i/r_concat.dat /fs/lustre/cwr0408/9.3.2014/outputs/r_concat_EtOHMix00_\$i.dat
done

for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18 PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/1.29.2014/$i
echo $i | ./AnalyzeGro4
cp /fs/lustre/cwr0408/1.29.2014/$i/r_concat.dat /fs/lustre/cwr0408/1.29.2014/outputs/r_concat_\$i.dat
done

for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18 PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/1.29.2014/$i
echo $i | ./AnalyzeGro4
cp /fs/lustre/cwr0408/1.29.2014/$i/r_concat.dat /fs/lustre/cwr0408/1.29.2014/outputs/r_concat_\$i.dat
done

for i in PE4 PE5 PE6 PE8 PE10 PE12 PE14 PE18 PE24 PP6 PP9 PP12 PP15 PP18 PIB12 PIB24 PIB36
do 
cd /fs/lustre/cwr0408/1.29.2014/$i
echo $i | ./AnalyzeGro4
cp /fs/lustre/cwr0408/1.29.2014/$i/r_concat.dat /fs/lustre/cwr0408/1.29.2014/outputs/r_concat_\$i.dat
done