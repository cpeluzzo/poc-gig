#!/bin/bash
#
# Simple script call URL
#

Help()
{
   # Display Help
   echo "Simple script to call a URL"
   echo
   echo "Syntax: $(basename $0) https://google.es"
   echo "If the URL == 200 script exit with 0"
   echo
}

call_url () {
  status_code=$($(command -v curl) -sL -o /dev/null -w "%{http_code}" "$1")
  if [[ "${status_code}" == 200 ]]; then
    echo -e "Status Code: ${status_code}"
    return 0
  else
    echo -e "Status Code: ${status_code}"
    return 1
  fi
}


verify_input () {
  
  # Get the options
  while getopts ":h" option; do
    case $option in
      h) # display Help
        Help
        exit;;
    esac
  done
  
  if [[ $# -gt 1 ]] || [[ $# -eq 0 ]]; then
    echo -e "\nThe number of parameters is not right\n"
    return 1
  elif [[ $# -eq 0 ]]; then
    echo -e "\nYou need to pass as \$1 a valid URL\n"
    return 1
  fi
}

main () {
  verify_input "$@" 
  call_url "$@" 
}

##
## MAIN
##

#Err on first fail
set -e

main "$@" 

exit $?
