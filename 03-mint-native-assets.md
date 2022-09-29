# Minting Native Assets

### Create Minting Keys

Policies are the defining factor under which tokens can be minted. Only those in possession of the policy keys can mint or burn tokens minted under this specific policy. We'll make a separate sub-directory in our work directory to keep everything policy-wise separated and more organized. For further reading, please check the official docs or the github page about multi-signature scripts.

First of all, we — again — need some key pairs:

```sh
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey
```

### Create a Policy Script

The file `policy/policy.script` is simple script file that defines the policy verification key as a witness to sign the minting transaction. There are no further constraints such as token locking or requiring specific signatures to successfully submit a transaction with this minting policy.

```sh
echo "{" >> policy/policy.script 
echo "  \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey)\"," >> policy/policy.script 
echo "  \"type\": \"sig\"" >> policy/policy.script 
echo "}" >> policy/policy.script
```

### Compute the Policy Id

To mint the native assets, we need to generate the policy ID from the script file we created.

```sh
cardano-cli transaction policyid --script-file ./policy/policy.script > policy/policy.id
```

The output gets saved to the file `policy.id` as we need to reference it later on.

### Define the Token to Mint

```
tokenname1="54657374746F6B656E"
tokenname2="5365636F6E6454657374746F6B656E"
tokenamount="10000000"
output="0"
```

### Build the Tx

Txs in Cardano are deterministic. An user building a Tx will need to provide all inputs, outputs, parameters, etc that describe the operation as a whole.

Following the above, the 1st step required to build a Tx is to gather the data of the inputs. For this, lets query the UTxO of our address by running the following command:

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```

> **Note**
> This is the same command we executed when we queried our funds earlier in the tutorial.

Since we need each of those values in our transaction, we will store them individually in a corresponding variable.

```sh
txhash="insert your txhash here"
txix="insert your TxIx here"
funds="insert Amount here"
policyid=$(cat policy/policy.id)
```

Also, transactions only used to calculate fees must still have a fee set, though it doesn't have to be exact. The calculated fee will be included the second time this transaction is built (i.e. the transaction to sign and submit). This first time, only the fee parameter length matters, so here we choose a maximum value (note):

```sh
fee="300000"
```

Now we are ready to build the first transaction to calculate our fee and save it in a file called matx.raw. We will reference the variables in our transaction to improve readability because we saved almost all of the needed values in variables. This is what our transaction looks like:

```sh
cardano-cli transaction build-raw \
 --babbage-era \
 --fee $fee \
 --tx-in $txhash#$txix \
 --tx-out $MY_ADDRESS+$funds+"$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
 --mint "$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
 --minting-script-file policy/policy.script \
 --out-file matx.raw
```

### Sign the Transaction

Transactions need to be signed to prove the authenticity and ownership of the policy key.

```sh
cardano-cli transaction sign  \
    --signing-key-file payment.skey  \
    --signing-key-file policy/policy.skey  \
    --testnet-magic $CARDANO_NODE_MAGIC \
    --tx-body-file matx.raw  \
    --out-file matx.signed
```

### Submit the Transaction

Now we are going to submit the transaction, therefore minting our native assets:

```sh
cardano-cli transaction submit --tx-file matx.signed --testnet-magic $CARDANO_NODE_MAGIC
```

Congratulations, we have now successfully minted our own token. After a couple of seconds, we can check the output address

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```