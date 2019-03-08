#! /bin/bash


################################################################################
# "MAIN" FUNCTION:                                                             #
################################################################################
if [[ $# -eq 0 || $# -lt 1 ]] ; then
    echo "Error in options passed!"
    echo ""
    usage
    exit 1
fi

COMMAND=$1

if [[ ${COMMAND} == "x" ]] ; then
  echo "iCub::r_hand 2 0 0 0 0 0 5" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-x" ]] ; then
  echo "iCub::r_hand -2 0 0 0 0 0 5" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "y" ]] ; then
  echo "iCub::r_hand 0 2 0 0 0 0 5" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-y" ]] ; then
  echo "iCub::r_hand 0 -2 0 0 0 0 5" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "z" ]] ; then
  echo "iCub::r_hand 0 0 2 0 0 0 5" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-z" ]] ; then
  echo "iCub::r_hand 0 0 -2 0 0 0 5" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

exit 0
