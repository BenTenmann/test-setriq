#!/bin/bash

# output colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

# check if >python3.7 is available
if ! command -v python3 &> /dev/null 
then
    echo "no python3 found. Please install python3.7 or greater"
    exit 1
fi

PY_VER="$(python3 --version | sed -E 's/Python 3\.([0-9]+)\.[0-9]/\1/g')"
if [[ $PY_VER -lt 7 ]]
then
   echo "python version too old. Please install at least Python3.7" 
   exit 1
fi


# setup environment
pip3 install virtualenv
python3 -m venv "${PWD}/venv"
PY_PATH="${PWD}/venv/bin/"

if [[ $1 == "no-omp" ]]
then
    if [[ "${OSTYPE}" == "linux-gnu"* ]]
    then
        sudo apt install libomp-dev && sudo apt show libom-dev
    elif [[ "${OSTYPE}" == "darwin"* ]]
    then
        brew install libomp llvm
    else
        echo "OS ${OSTYPE} not recognised"
        exit 1
    fi
fi

"${PY_PATH}/pip" install --extra-index-url=https://test.pypi.org/simple/ setriq
RES=$("${PY_PATH}/python3" -c "import setriq; metric = setriq.Levenshtein(); d = metric(['AASQ', 'PASQ']); print(d)")

if [[ "${RES}" == "[1.0]" ]]
then
    echo -e "${GREEN}tests passed${NC}"
    exit 0
else
    echo -e "${RED}tests failed${NC}"
    exit 1
fi

