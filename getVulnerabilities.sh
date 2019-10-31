#!/bin/bash

source harborScan/config.properties

# Usage of this script

usage () {
    printf "\n"
    echo "usage: getVulnerabilities.sh --dept-name <> --app-name <> --app-version <>"
    printf "\n"
}

# Process command line args

if [ -z "$1" ]; then usage && exit 1; fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --dept-name)
    if [ -z "$2" ]; then
      echo >&2 "Error: Required Department Name, Application Name and Application Variable."
      usage
      exit 1
    fi
	Dept_Name="$2"
    shift # past argument
    shift # past value
    ;;
    --app-name)
    App_Name="$2"
	if [ -z "$3" ]; then
      echo >&2 "Error: Required Application Name and Application Variable."
      usage
      exit 1
    fi
	shift # past argument
    shift # past value
    ;;
    --app-version)
    App_Version="$2"
        shift # past argument
        shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    echo >&2 "Error: unknown option $1"
    usage
    exit 1
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

isVulnerable=$(curl -u $HRBR_USR:$HRBR_PWD  -X GET "https://$HRBR_NODE/api/repositories/$Dept_Name/$App_Name/tags/$App_Version/vulnerability/details")
secure=[]

if [ "$isVulnerable" != "$secure" ]; then
    echo " $Dept_Name - $App_Name : $App_Version " >> $WORK_DIR/notifyTo/$Dept_Name
    echo " $Dept_Name - $App_Name : $App_Version " >> $WORK_DIR/vulnerableImages.txt
fi
