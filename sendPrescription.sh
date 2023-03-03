#!/bin/bash

# Script is brought to you by DANIEL WEB3 RODRIGUEZ, Telegram @BreakpointDaniel
# Stakepool scripts ATADA : 
#                           TESTNET:    https://github.com/gitmachtl/scripts/tree/master/cardano/testnet
#                           MAINNET:    https://github.com/gitmachtl/scripts/tree/master/cardano/mainnet

#Check the commandline parameter
if [[ $# -eq 1 && ! $1 == "" ]]; then metadatafile="$(dirname $1)/$(basename $1 .json)"; metadatafile=${metadatafile/#.\//}; else echo "ERROR - Usage: $0 <metadata file name>"; exit 2; fi

#send metadata file into a variable
METADATA_FILE="${metadatafile}.json"

#Check if metadatafile file exists, create a transacion with metadata added
if [ -f "${metadatafile}.json" ]; then
    echo 'Información de Metadata';

    echo $METADATA_FILE;
    cardano-cli query tip --testnet-magic 2;

    #typeOfAddr=$(cardano-cli query utxo --testnet-magic 2 --address $ADDRESS);
    #echo $typeOfAddr;
    #if [[ ${typeOfAddr} == ${addrTypePayment} || ${typeOfAddr} == ${addrTypeStake} ]]; then echo "$(basename ${addrName})" > ${tempDir}/tempAddr.addr; addrName="${tempDir}/tempAddr";


    #cardano-cli query utxo --testnet-magic 2 --address $ADDRESS
    ./01_sendLovelaces.sh my_address other_address 'MIN' $METADATA_FILE;

fi