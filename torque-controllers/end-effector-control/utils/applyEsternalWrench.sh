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

FORCE=4.5
TIME=1.5

if [[ ${COMMAND} == "x" ]] ; then
  echo "iCub::r_hand ${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-x" ]] ; then
  echo "iCub::r_hand -${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "y" ]] ; then
  echo "iCub::r_hand 0 ${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-y" ]] ; then
  echo "iCub::r_hand 0 -${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "z" ]] ; then
  echo "iCub::r_hand 0 0 ${FORCE} 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-z" ]] ; then
  echo "iCub::r_hand 0 0 -${FORCE} 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

exit 0
