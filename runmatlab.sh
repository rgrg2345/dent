#!/bin/bash -e
export PATH=/usr/bin:/usr/sbin:/bin:/sbin
export M_PATH=/Applications/MATLAB_R2016b.app/bin/matlab
export DEST_PATH=~/Desktop/NTU/MVNL/dent/

python $DEST_PATH"batch_extract.py" $1 $2
s=$1
func=""
hz=920

#padding ''.join(['0' for i in range(5-len(str(idx)))])+str(idx)
#684 791 870 920

for ((i=$s;i<=$2;i=i+1))
do
  fn=`python -c "print ''.join(['0' for i in range(5-len(str($i)))])+str($i)"`
  if [ "$#" -gt 2 ]; then
    func=$func", plotfft($hz,'$fn.txt',15000,'$3');,readfft($hz,'$fn.txt','$fn');,"
  else
    func=$func", plotfft($hz,'$fn.txt',15000,'');,readfft($hz,'$fn.txt','$fn');,"
  fi
done

#plot sampling fft
len=`python -c "print ($2-$1+1)/4"`
func2=""

for ((i=1;i<=$len;i=i+1))
do
  s=`python -c "print ($1+($i-1)*4)"`
  end=`python -c "print $s+3"`
  func2=$func2", mat2fft('./',$s,$end, $hz)"
done

#check for last
res=`python -c "print int((float($2-$1+1)/4>($2-$1+1)/4))"`
mod=`python -c "print (($2-$1+1)%4-1)"`
if [ $res -gt 0 ]; then
  s=`python -c "print $2-($2-$1)%4"`
  end=`python -c "print ($s+$mod)"`
  func2=$func2", mat2fft('./',$s,$end, $hz)"
fi

$M_PATH -nodesktop -nosplash -r "cd '$DEST_PATH'$func, $func2, quit;"

exit
