# Minting Native Assets

### Create Minting Keys

Policies are the defining factor under which tokens can be minted. Only those in possession of the policy keys can mint or burn tokens minted under this specific policy. We'll make a separate sub-directory in our work directory to keep everything policy-wise separated and more organized. For further reading, please check the official docs or the github page about multi-signature scripts.

First of all, we — again — need some key pairs:

```sh
cardano-cli address key-gen \
    --verification-key-file asset_policy.vkey \
    --signing-key-file asset_policy.skey
```

## Hash the Key

We need to find the hash of the key we just generated, it will be used as data to create the policy script:

```sh
cardano-cli address key-hash --payment-verification-key-file asset_policy.vkey
```

Remeber the value for the next step.

### Create a Policy Script

We need to create a file that defines the policy verification key as a witness to sign the minting transaction. There are no further constraints such as token locking or requiring specific signatures to successfully submit a transaction with this minting policy.

Create a new `policy.script` with the following json content, replacing the required values with the data gathered in the previous steps:

```json
{
    "keyHash": "<POLICY_HASH>",
    "type": "sig"
}
```

> **Warning**
> make sure to replace the `<POLICY_HASH>` string with the value computed in the previous step.

### Compute the Policy Id

To mint the native assets, we need to generate the policy ID from the script file we created.

```sh
cardano-cli transaction policyid --script-file policy.script > policy.id
```

The output gets saved to the file `policy.id` as we need to reference it later on.

### Define the Token to Mint

We need to defined the name for our token and the amount that we want to mint. Use the following snippet to define the values to use in following steps:

```
TOKEN_NAME="54657374746F6B656E"
TOKEN_AMOUNT="10000000"
```

### Build the Tx

As we saw in part [02](./02-build-transactions.md) of the tutorial, building a transaction requires knowledge of the available UTxO in the address. Use the following command to query our address:

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```

> **Note**
> This is the same command we executed when we queried our funds earlier in the tutorial.

Since we need each of those values in our transaction, we will store them individually in a corresponding variable.

```sh
TX_HASH="insert your txhash here"
TX_IX="insert your TxIx here"
TX_AMOUNT="insert your existing amount here"
```

We'll also need the ID of the policy, so lets load a variable with the correspondinf value for easier access:

```sh
POLICY_ID=$(cat policy.id)
```

Our transaction will require to pay fees. For simplicity (and because we're using test ADA), we'll just put a high number to ensure that we cover the required amount:

```sh
FEE=200000
```

To balance the transaction, we need to know which will be the remaining amount of our UTxO once we pay the fees. For that, we calculate the value using the following command:

```sh
let REMAINING=$TX_AMOUNT-$FEE
```

We will reference the variables in our transaction to improve readability because we saved almost all of the needed values in variables. This is what our transaction looks like:

```sh
cardano-cli transaction build-raw \
 --fee $FEE \
 --tx-in $TX_HASH#$TX_IX \
 --tx-out $MY_ADDRESS+$REMAINING+"$TOKEN_AMOUNT $POLICY_ID.$TOKEN_NAME" \
 --mint "$TOKEN_AMOUNT $POLICY_ID.$TOKEN_NAME" \
 --minting-script-file policy.script \
 --out-file mint.raw
```

### Sign the Transaction

Transactions need to be signed to prove the authenticity and ownership of the policy key.

```sh
cardano-cli transaction sign  \
    --signing-key-file my_address.skey  \
    --signing-key-file asset_policy.skey  \
    --testnet-magic $CARDANO_NODE_MAGIC \
    --tx-body-file mint.raw  \
    --out-file mint.signed
```

### Submit the Transaction

Now we are going to submit the transaction, therefore minting our native assets:

```sh
cardano-cli transaction submit --tx-file mint.signed --testnet-magic $CARDANO_NODE_MAGIC
```

Congratulations, we have now successfully minted our own token. After a couple of seconds, we can check the output address

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```

After a few seconds, you should be able to see that your address holds the newly minted assets:

```sh
TxHash          TxIx     Amount
--------------------------------------------------------------------------------------
d270...77e5     0        9998470134 lovelace + 10000000 5ec1...3b76.54657374746f6b656e
```