# Intro

This script is a community effort to facilitate the creation of AVAX Nodes on Mainnet
This script automates the steps of the following guide https://github.com/ava-labs/avalanchego


# PRE REQUISITES

This script has been tested on AWS with a ubuntu instance.

## Usage

  1. Connect to your VPS
  2. launch the following command
```shell
curl -s https://raw.githubusercontent.com/ablockio/AVAX-node-installer/master/install.sh | bash
```
  3. Once done, you verify that the status of your node is running
  4. Execute the curl command to get your node Id
```shell
curl -X POST --data '{
  "jsonrpc":"2.0",
  "id"     :1,
  "method" :"info.getNodeID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```
  5. Save your `stake.key` for your secret. Full instruction here : https://docs.avax.network/v1.0/en/staking/
  6. Follow the instruction to add your stake as a validator on https://docs.avax.network/v1.0/en/tutorials/adding-validators/


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
