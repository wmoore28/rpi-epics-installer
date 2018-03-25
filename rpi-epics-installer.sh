#!/bin/bash

# If not root, rerunning with sudo...
[ "$(whoami)" != "root" ] && exec sudo -- "$0"

# needed for copying files from current working directory
workdir=`pwd`

# If at JLab, add proxy and certs
ipaddr=`ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`
if [[ $ipaddr == 129.57.* ]]; then
    . $workdir/proxyrc
    echo "Downloading latest jlab certificates..."
    cd /usr/local/share/ca-certificates
    curl -sLO https://pki.jlab.org/JLabCA.crt
    update-ca-certificates
fi

# Setup EPICS environmental variables
. $workdir/epicsrc

echo "Installing EPICS base..."
if [ ! -d ${EPICS_TOP} ]; then
    mkdir ${EPICS_TOP}
fi
cd ${EPICS_TOP}
echo "-- Installing EPICS env file"
cp $workdir/epicsrc .epicsrc
if [ ! -e ${EPICS_BASE} ]; then
    curl -LO http://www.aps.anl.gov/epics/download/base/baseR${EPICS_VERSION}.tar.gz
    tar xvzf baseR${EPICS_VERSION}.tar.gz
    rm *.gz
    ln -s base-${EPICS_VERSION} base
    cd base
    make install
else
    echo "EPICS base already exists at ${EPICS_BASE}"
fi

echo "Installing EPICS extensions..."
if [ ! -d ${EPICS_EXTENSIONS} ]; then
    cd ${EPICS_TOP}
    git clone https://github.com/wmoore28/epics-extensions extensions
    cd extensions
    make
else
    echo "EPICS extensions already installed at ${EPICS_EXTENSIONS}"
fi

echo "Installing synApps..."
if [ ! -d ${EPICS_TOP}/support ]; then
    cd ${EPICS_TOP}
    curl -LO https://www.aps.anl.gov/files/APS-Uploads/BCDA/synApps/tar/synApps_5_8.tar.gz
    tar xvf synApps_5_8.tar.gz
    ln -s synApps_5_8/support support
    rm *.gz
    cd support
    cp $workdir/synApps_RELEASE configure/RELEASE
    sed -i "s/EPICS_MODULES/#EPICS_MODULES/" devIocStats-*/configure/RELEASE
    make release
    make
else
    echo "synApps already installed at ${EPICS_TOP}/support"
fi

echo "COMPLETE"

