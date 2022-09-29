# Build Transactions

In this tutorial, we'll attempt to create a simple transaction that transfer ADA from one address to another.

## Generate Address for the Destinatary

In part [01](./01-account-management.md) we created our own address and added some funds. Since the goal of this part is to transfer ADA, we'll need to do the same for the destinatary of the transfer.

Run the key-gen command again, but output the keys to different files.

```sh
cardano-cli address key-gen --verification-key-file other_address.vkey --signing-key-file other_address.skey
```

Those two keys can now be used to generate an address.

```sh
cardano-cli address build --payment-verification-key-file other_address.vkey --out-file other_address.addr --testnet-magic $CARDANO_NODE_MAGIC
```

We will save our address hash in a variable called address.

```sh
OTHER_ADDRESS=$(cat other_address.addr)
```

## Build the Tx Payload

Txs in Cardano are deterministic. An user building a Tx will need to provide all inputs, outputs, parameters, etc that describe the operation as a whole.

Following the above, the 1st step required to build a Tx is to gather the data of the inputs. For this, lets query the UTxO of our address by running the following command:

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```

> **Note**
> This is the same command we executed when we queried our funds in part 01 of the tutorial.

Lets say that we have a result similar to the following:

```sh
TxHash            TxIx     Amount
----------------------------------------------------------------
a8d58d9...eda     0        10000000000 lovelace + TxOutDatumNone
```

Since we need each of those values in our transaction, we will store them individually in a corresponding variable.

```sh
MY_TX_HASH="insert your txhash here"
MY_TX_IX="insert your TxIx here"
MY_FUNDS="insert Amount here"
```

Now we need to define how much we want to transfer. It needs to be less than the amount of available funds, also taking into account the fees for the transfer.

```sh
TRANSFER_AMOUNT="500000"
```

Now we are ready to build the first transaction to calculate our fee and save it in a file called matx.raw. We will reference the variables in our transaction to improve readability because we saved almost all of the needed values in variables. This is what our transaction looks like:

```sh
cardano-cli transaction build \
 --testnet-magic $CARDANO_NODE_MAGIC \
 --tx-in $MY_TX_HASH#$MY_TX_IX \
 --tx-out $OTHER_ADDRESS+$TRANSFER_AMOUNT \
 --out-file transfer.raw
```

### Sign the Transaction

Transactions need to be signed to prove the authenticity and ownership of the policy key.

```sh
cardano-cli transaction sign  \
    --signing-key-file other_address.skey  \
    --testnet-magic $CARDANO_NODE_MAGIC \
    --tx-body-file transfer.raw  \
    --out-file transfer.signed
```

### Submit the Transaction

Now we are going to submit the transaction by running the following command:

```sh
cardano-cli transaction submit --tx-file transfer.signed --testnet-magic $CARDANO_NODE_MAGIC
```

Congratulations, we have now successfully transfered some ADA. After a couple of seconds, we can check the output address

```sh
cardano-cli query utxo --address $OTHER_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```