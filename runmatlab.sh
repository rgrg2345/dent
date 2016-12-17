#!/bin/bash -e
export PATH=/usr/bin:/usr/sbin:/bin:/sbin
export M_PATH=/Applications/MATLAB_R2016b.app/bin/matlab
export DEST_PATH=~/Desktop/NTU/MVNL/dent/

python $DEST_PATH"batch_extract.py" $1 $2
s=$1
func=""
for ((i=$s;i<=$2;i=i+1))
do
  if [ "$#" -gt 2 ]; then
    func=$func", plotfft(684,'00$i.txt',15000,'$3');,"
  else
    func=$func", plotfft(684,'00$i.txt',15000,'');,"
  fi
done
$M_PATH -nodesktop -nosplash -r "cd '$DEST_PATH'$func, quit;"

exit
