#!/bin/bash

# Script is brought to you by DANIEL WEB3 RODRIGUEZ, Telegram @BreakpointDaniel
# Stakepool scripts ATADA : 
#                           TESTNET:    https://github.com/gitmachtl/scripts/tree/master/cardano/testnet
#                           MAINNET:    https://github.com/gitmachtl/scripts/tree/master/cardano/mainnet

#Check the commandline parameter
if [[ $# -eq 1 && ! $1 == "" ]]; then receta_id="$(dirname $1)/$(basename $1 .json)"; receta_id=${receta_id/#.\//}; else echo "ERROR - Usage: $0 <receta_id>"; exit 2; fi

#send metadata file into a variable
METADATA_FILE="${receta_id}.json"

#Check if receta_id not file exists, I create a metadata file 
if [ ! -f "${receta_id}.json" ]; then
    echo 'Información de Metadata';

    echo $METADATA_FILE;
    cardano-cli query tip --testnet-magic 2;  

    #create metadata file based on parameter
    cat > $METADATA_FILE <<EOF
    {
        "${receta_id}": {
            "name": "Receta Electronica Citaldoc",
            "Rp": "Ácido acetil Salisílico (Deliciosa Aspirina) 500mg.",
            "Indicaciones": "Clavátela 28 veces al dia por dos x 2 meses a la misma hora."
        }
    }
EOF

    echo "------------------------------------------------------------"
   
    echo  "Creado Archivo JSON.";
    echo  "Script Completado.";

    ./01_sendLovelaces.sh my_address other_address 'MIN' $METADATA_FILE;
else
    echo "El archivo de metadata para la receta ID = ${receta_id} ya existe.";
fi