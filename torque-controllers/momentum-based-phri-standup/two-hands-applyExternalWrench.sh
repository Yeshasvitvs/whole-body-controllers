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

FORCE=25
TIME=10.0
ROBOT="iCub"
LEFT_LINK="l_hand"
RIGHT_LINK="r_hand"

#echo "multiple" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i

if [[ ${COMMAND} == "x" ]] ; then
  echo "${LEFT_LINK} ${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
  echo "${RIGHT_LINK} ${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-x" ]] ; then
  echo "${LEFT_LINK} -${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
  echo "${RIGHT_LINK} -${FORCE} 0 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "y" ]] ; then
  echo "${LEFT_LINK} 0 ${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
  echo "${RIGHT_LINK} 0 ${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-y" ]] ; then
  echo "${LEFT_LINK} 0 -${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
  echo "${RIGHT_LINK} 0 -${FORCE} 0 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "z" ]] ; then
  echo "${LEFT_LINK} 0 0 ${FORCE} 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
  echo "${RIGHT_LINK} 0 0 ${FORCE} 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
fi

if [[ ${COMMAND} == "-z" ]] ; then
  echo "${LEFT_LINK} 0 0 -${FORCE} 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
  echo "${RIGHT_LINK} 0 0 -${FORCE} 0 0 0 ${TIME}" | yarp rpc /${ROBOT}/applyExternalWrench/rpc:i
fi

exit 0
