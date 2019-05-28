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

FORCE=10
TIME=0.75
EE_LINK="iCub::r_hand"

if [[ ${COMMAND} == "x" ]] ; then
  echo "${EE_LINK} ${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-x" ]] ; then
  echo "${EE_LINK} -${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "y" ]] ; then
  echo "${EE_LINK} 0 ${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-y" ]] ; then
  echo "${EE_LINK} 0 -${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "z" ]] ; then
  echo "${EE_LINK} 0 0 ${FORCE} 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-z" ]] ; then
  echo "${EE_LINK} 0 0 -${FORCE} 0 0 0 ${TIME}" | yarp rpc /iCub/applyExternalWrench/rpc:i
fi

exit 0
