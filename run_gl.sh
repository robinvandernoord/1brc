setting=$1
# script=$2
output=answer_gleam_${setting}.txt

if [ -z "${setting}" ]; then
  echo 'no setting passed!'
  exit 1
fi

# if [ -z "${script}" ]; then
#   echo 'no script passed!'
#   exit 1
# fi

rm measurements.txt
ln -s measurements_${setting}.txt measurements.txt

# don't have much choice here since it's defined in gleam.toml ...
exe='./naive'
gleam run -m gleescript
time $exe > $output

cmp --silent answer_${setting}.txt $output || echo 'WRONG'
