# fcs_wallet

## setup

```bash
cp .env.sample .env
bin/setup
```

## CLI

```bash
# start wallet
bin/cli startwallet

# stop wallet
bin/cli stopwallet

# show wallet status
bin/cli statuswallet

# get token balance (if color_id not specified, show TPC balance)
bin/cli getbalance <color_id>

# show UTXO list
bin/cli listunspent

# dump private key
bin/cli dumpprivkey

# dump public key
bin/cli dumppubkey
```
