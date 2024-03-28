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

# time python $script > $output
# /usr/bin/time -f "| $script | python3.10 | %E | %U | %S | %P | %M | |" python3.10 $script > $output
/usr/bin/time -f "| $script | python3.11 | %E | %U | %S | %P | %M | |" python3.11 $script > $output
# /usr/bin/time -f "| $script | python3.12 | %E | %U | %S | %P | %M | |" python3.12 $script > $output

cmp --silent answer_${setting}.txt $output || echo 'WRONG'
