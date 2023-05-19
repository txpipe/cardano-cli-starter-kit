//Address usada: addr_test1vp2l080u4lzhwvfq7exlncw2tye2crr5wl9f0vxgh9ewctsy5dk43
import * as fs from 'fs';
// Agregar esta dependencia usando: npm install node-cmd
import cmd from 'node-cmd';

// Ruta que apunta a cardano-cli de uso global
const CARDANO_CLI_PATH = "cardano-cli";
// El numero identificatorio de  `testnet` (2 para workspace de Dameter.run)
const CARDANO_NETWORK_MAGIC = 2; //1097911063;
// Directorio donde almacenamos las Keys
// asumiento que el $HOME/workspace/repo es "./"
const CARDANO_KEYS_DIR = "keys";

// Leemos el valor de la wallet address desde el archivo payment.addr 
const walletAddress = fs.readFileSync(`${CARDANO_KEYS_DIR}/my_address.addr`).toString();

// Usamos la libreria npm "node-cmd" para ejecutar comandos shell y leer los UTXO
const rawUtxoTable = cmd.runSync([
    CARDANO_CLI_PATH,
    "query", "utxo",
    "--testnet-magic", CARDANO_NETWORK_MAGIC,
    "--address", walletAddress
].join(" "));

// Calculate total lovelace of the UTXO(s) inside the wallet address
const utxoTableRows = rawUtxoTable.data.trim().split('\n');
console.log(utxoTableRows);

let totalLovelaceRecv = 0;
let haySaldo = false;

for (let x = 2; x < utxoTableRows.length; x++) {
    const cells = utxoTableRows[x].split(" ").filter(i => i);
    totalLovelaceRecv += parseInt(cells[2]);
    console.log(cells);
}

// Determine if the total lovelace received is more than or equal to
// the total expected lovelace and displaying the results.
haySaldo = !(totalLovelaceRecv == 0);

console.log(`Total Received: ${totalLovelaceRecv} LOVELACE`);
console.log(`Hay Saldo: ${(haySaldo ? "✅" : "❌")}`);

// cardano-cli transaction build-raw \
//     --tx-in 4e3a6e7fdcb0d0efa17bf79c13aed2b4cb9baf37fb1aa2e39553d5bd720c5c99#4 \
//     --tx-out $(cat payment2.addr)+0 \
//     --tx-out $(cat payment.addr)+0 \
//     --invalid-hereafter 0 \
//     --fee 0 \
//     --out-file tx.draft