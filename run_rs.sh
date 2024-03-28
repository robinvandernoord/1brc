setting=$1
script=$2
output=answer_${script}_${setting}.txt

if [ -z "${setting}" ]; then
  echo 'no setting passed!'
  exit 1
fi

if [ -z "${script}" ]; then
  echo 'no script passed!'
  exit 1
fi

rm measurements.txt
ln -s measurements_${setting}.txt measurements.txt

exe=/tmp/$script.exe

rustc -C opt-level=3 -o $exe $script
# time $exe > $output
/usr/bin/time -f "| $script | rs -C opt-level=3 | %E | %U | %S | %P | %M | |" $exe > $output


cmp --silent answer_${setting}.txt $output || echo 'WRONG'
