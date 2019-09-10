step=0
year=2016
ev=100000
for mode in n3n2-n1-hbb-hbb
do
	#for mchi in 127 150 175 200 225 250 275 300 325 350 375 400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875 900 925 950 975
	for mchi in 200 
	do	
		#for pl in 1000
		for pl in prompt 100 1000 10000
		do
			./lhe_to_aod_${year}.sh ${step} ${mchi} ${pl} ${ev} ${mode}
			echo "completed ${mode} ${mchi}  ${pl}"
		done
	done
done

