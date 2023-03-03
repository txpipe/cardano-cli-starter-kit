#!/bin/bash

# Script is brought to you by DANIEL WEB3 RODRIGUEZ, Telegram @BreakpointDaniel


#Check the commandline parameter
if [[ $# -eq 1 && ! $1 == "" ]]; then addrName="$(dirname $1)/$(basename $1 .addr)"; addrName=${addrName/#.\//}; else echo "ERROR - Usage: $0 <AdressName or HASH or '\$adahandle'>"; exit 2; fi

#send address into a variable
#ADDRESS="${addrName}"
ADDRESS="addr_test1vp2l080u4lzhwvfq7exlncw2tye2crr5wl9f0vxgh9ewctsy5dk43";

#Check if addrName file does not exists, make a dummy one in the temp directory and fill in the given parameter as the hash address
if [ ! -f "${addrName}.addr" ]; then
    echo 'Información de TIP';

    echo $ADDRESS;
    cardano-cli query tip --testnet-magic 2;

    typeOfAddr=$(cardano-cli query utxo --testnet-magic 2 --address $ADDRESS);
    echo $typeOfAddr;
    #if [[ ${typeOfAddr} == ${addrTypePayment} || ${typeOfAddr} == ${addrTypeStake} ]]; then echo "$(basename ${addrName})" > ${tempDir}/tempAddr.addr; addrName="${tempDir}/tempAddr";


    #cardano-cli query utxo --testnet-magic 2 --address $ADDRESS

fi