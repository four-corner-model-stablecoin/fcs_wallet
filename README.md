# fcs_wallet

## Setup

```bash
cp .env.sample .env
```

and place your jwk.json to `config/credentials/jwk.json`

## CLI

```bash
$ bin/cli help
Commands:
  cli createdid                                    # Create DID.
  cli dumpprivkey                                  # Dump private key.
  cli dumppubkey                                   # Dump public key.
  cli getbalance <color_id>                        # Get current balance. If color_id specified show balance of token.
  cli help [COMMAND]                               # Describe available commands or one specific command
  cli listunspent                                  # Show UTXO list
  cli removedid                                    # Remove DID from the wallet.
  cli removevc                                     # Remove VC from the wallet.
  cli sendtovc <issuer url> <vc> <amount>          # Send withdraw request to acquirer.
  cli sendwithdrawrequest <acquirer url> <amount>  # Send withdraw request to acquirer.
  cli showdid                                      # Show DID stored in the wallet.
  cli showvc                                       # Show VC.
  cli startwallet                                  # Start wallet as daemon.
  cli statuswallet                                 # Show wallet status.
  cli stopwallet                                   # Stop wallet daemon.
  cli storevc <vc>                                 # Store VC.
```
