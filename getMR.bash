#!/usr/bin/env bash

warn(){
 echo $@ >&2
}

#study=rescan
#studydir=/Volumes/Phillips/Raw/MRprojects/MultiModal

[ -z "$2" ] && echo "USAGE: $0 study /path/to/raw;\n$0 rescan /Volumes/Phillips/Raw/MRprojects/MultiModal" && exit 1
study="$1"
studydir=$2
[ ! -d "$studydir" ] && warn "cannot find study raw dir '$studydir'" && exit 1

input=txt/$study/$study.txt 
[ ! -r $input ] && warn "cannot find input cal info $input; run getCal.bash $study"


pastdir="empty"

minmaxtime(){
 ./MRtimes.bash $1/*/ | 
  tee txt/$study/alltimes.txt  |
  cut -d' ' -f 2- |
  tr ' ' '\n' |
  sort |
  # first and last
  sed -n '1p;$p'|
  # put a ':' after every 2 numbers. remove everything including and after ':.'
  perl -pe 's/\d{2}/$&:/g;s/:\..*//'|
  tr '\n' ' '
}

while read scandate scantime age sex; do
  sdate=${scandate//-/.}

  [ -z "$sex" ] && warn "unexpected input from text file" && continue

  dir=$(ls -d $studydir/$sdate-* 2>/dev/null|sed 1q)
  if [ "$dir" == "$prevdir" ]; then
    warn "$dir found twice trying new"
    dir=$(ls -d $studydir/$sdate-* 2>/dev/null|sed 1d)
  fi
  [ -z "$dir" ] && warn "no dir $studydir/$sdate-* for $scandate $scantime $age $sex" && continue


  MRstartfinish=$(minmaxtime $dir)
  echo "$scandate $age $sex $scantime:00 $MRstartfinish"

  prevdir=$dir
done < txt/$study/$study.txt | tee txt/$study/times.txt
