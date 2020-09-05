#!/bin/bash

#set -x

if [ $# -ne 1 ]; then
   echo "Usage: $0 <patch file name (e.g. libcoap.cisco_specific.1.0.0.06292019)> "

   exit 1
fi

#
# Be user friendly and compensate for being in wrong directory
#
pdir=`basename $PWD`
if [ "$pdir" = "scripts" ]; then

    cd ..
    pdir=`basename $PWD`
    if [ "$pdir" != "libcoap" ]; then
        echo "Please run this script from libcoap/ or libcoap/scripts"
        exit 1
    fi
fi

#
# Place the patch file into the top level directory
#
PATCHFILE=./$1.patch
echo "Creating $PATCHFILE..."

#
# The diff generated below will include all the changes we've added to the 
# Cisco specific branch.
#

git diff origin/develop..feature/libcoap_cisco_develop | tee $PATCHFILE

#
# To adhere to PSB requirement SEC-CHK-PUBL-2, use SHA512 hashes for
# validating downloaded software
#
echo "Creating SHA-512 file for $PATCHFILE..."
openssl dgst -sha512 $PATCHFILE | tee $PATCHFILE.sha512

#cat $PATCHFILE.sha512

ls -l $PATCHFILE*
