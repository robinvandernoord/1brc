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

target="3.11"
script_out=/tmp/coconut.py

args="--target $target --no-tco"

coconut $args $script $script_out || exit 1

/usr/bin/time -f "| $script | coconut $args | %E | %U | %S | %P | %M | |" python$target $script_out > $output

cmp --silent answer_${setting}.txt $output || echo 'WRONG'
