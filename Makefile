all: img/scanduration.png

img/scanduration.png: txt/p5/times.txt txt/rescan/times.txt
	./timediff.R

txt/rescan/rescan.txt:
	./getCal.bash rescan "Rescan"      

txt/p5/p5.txt: 
	./getCal.bash p5 "sz -MMY4"      

txt/p5/times.txt:
	./getMR.bash p5 /Volumes/Phillips/Raw/MRprojects/P5Sz

txt/rescan/times.txt:
	./getMR.bash rescan /Volumes/Phillips/Raw/MRprojects/MultiModal
