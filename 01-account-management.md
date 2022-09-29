
## Account Management Tutorial

### Generate keys and address

If you already have a payment address and keys and you want to use those, you can skip this step. If not - we need to generate those to submit transactions and to send and receive ada or native assets. Payment verification and signing keys are the first keys we need to create.

```sh
cardano-cli address key-gen --verification-key-file my_address.vkey --signing-key-file my_address.skey
```

Those two keys can now be used to generate an address.

```sh
cardano-cli address build --payment-verification-key-file my_address.vkey --out-file my_address.addr --testnet-magic $CARDANO_NODE_MAGIC
```

We will save our address hash in a variable called address.

```sh
MY_ADDRESS=$(cat my_address.addr)
```

### Fund the address

Submitting transactions always require you to pay a fee. Sending native assets requires also requires sending at least 1 ada. So make sure the address you are going to use as the input for the minting transaction has sufficient funds.

For the testnet, you can request funds through the [testnet faucet](https://docs.cardano.org/cardano-testnet/tools/faucet).

### Query address funds

Once we've finished requesting funds from the corresponding faucet, we can query the node to ensure that our address now displays the expected amount. For that, we execute the query utxo command using our recently generated address:

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```

We should get a result similar to the following:

```sh
TxHash            TxIx     Amount
----------------------------------------------------------------
a8d58d9...eda     0        10000000000 lovelace + TxOutDatumNone
```
