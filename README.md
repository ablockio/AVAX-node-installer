# Intro

This script is a community effort to facilitate the creation of AVAX Nodes on Mainnet
This script automates the steps of the following guide https://github.com/ava-labs/avalanchego


# PRE REQUISITES

This script has been tested on AWS with a ubuntu instance.

## Usage to install

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

## Usage to update
THE UPDATE SCRIPT IS TO BE USED ONLY FOR PERSONS USING UBUNTU AND HAVE USED OUR INSTALL SCRIPT.
THE SCRIPT IS OPEN SOURCED. VERIFY YOUR NODE STATUS AFTER YOU DID UPDATE IT

  1. Connect to your VPS and go to your $HOME dir
  2. launch the following command to get the script
  ```shell
  wget https://raw.githubusercontent.com/ablockio/AVAX-node-installer/master/update.sh > update.sh
  ```
  3. Grant the file the right to be executed
  ```shell
  chmod 777 update.sh
  ```
  4. If you have specific config for your node, define it on a new file `configNode.txt`

  ```shell
  sudo su
  cd $HOME
  vi configNode.txt
  ```
  This file shall have Node parameters ONLY. for example :
  ```shell
  -api-admin-enabled=true -api-health-enabled=true
  ```
  This file will remain untouched even if we update the script. You can keep the same config on each updates !
  5. Go back to your context
  If you did configured the `configNode.txt` file, do `exit; cd $HOME`

  6. Finally update
  ```shell
  ./update.sh 1.0.1
  ```
  This commands installs the 1.0.1 and runs it.



## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
