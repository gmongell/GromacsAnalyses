

module load gromacs/4.6.3


cd $PBS_O_WORKDIR

#Different h-bond types
#echo 1 2\n | g_hbond -f md_concat.trr -s md1.tpr -n index2.ndx -num hbnum.xvg
#echo 1 5\n | g_hbond -f md_concat.trr -s md1.tpr -n index2.ndx -num hbnum2.xvg
#echo 5 5\n | g_hbond -f md_concat.trr -s md1.tpr -n index2.ndx -num hbnum3.xvg

#Total H-bonds
echo 2 2\n | g_hbond -f md_concat.trr -s md1.tpr -num hbnum3.xvg

#;echo 1 5\n | g_hbond -f md_out.gro -s md1.tpr -n index2.ndx -num hbnum.xvg
