function trim() {
  if [[ $# == 0 ]]; then
    string=$(</dev/stdin)
  else
    string="$1"
  fi
  echo "$string" | trimStart | trimEnd
}
function trimEnd() {

  if [[ $# == 0 ]]; then
    string=$(</dev/stdin)
  else
    string="$1"
  fi

  # echo "${string// *$/}"
  echo "$string" | sed 's/ *$//g'
}
function trimStart() {
  if [[ $# == 0 ]]; then
    string=$(</dev/stdin)
  else
    string="$1"
  fi

  # echo "${string//^ */}"
  echo "$string" | sed 's/^ *//g'
}
