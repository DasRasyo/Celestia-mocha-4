#!/bin/bash


echo -e "                                                       ";
echo -e "   ______                                              ";
echo -e "  / ____/___  ____  ____ ___  _____  _________  _____  ";
echo -e " / /   / __ \/ __ \/ __  / / / / _ \/ ___/ __ \/ ___/  ";
echo -e "/ /___/ /_/ / / / / /_/ / /_/ /  __/ /  / /_/ / /      ";
echo -e "\____/\____/_/ /_/\__  /\__ _/\___/_/   \____/_/       ";
echo -e "                    /_/                                ";
echo -e "                                                       ";

echo -e "\033[38;5;245mTwitter : https://x.com/cqrlabs_tech\033[0m"
echo -e "\033[38;5;245mGithub  : https://github.com/DasRasyo\033[0m"
echo -e "\033[35mCelestia - Modularism, not maximalism\033[0m"

sleep 5

echo "Which node would you like to install? (l: light node, f: full node, b: bridge node, v: validator node)"
read node_type

case $node_type in
  l)
    echo -e "\033[35mLight Node! Good Choice!\033[0m"
sleep 7
echo -e "\033[38;5;205m⚠️Starting with Packages update and Dependencies Install⚠️\033[0m"
sleep 5

sudo apt update && apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential \
git make ncdu -y 

sleep 5

echo -e "\033[38;5;205m⚠️Installing GO⚠️\033[0m"

sleep 10

cd $HOME
curl -Ls https://go.dev/dl/go1.21.1.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
touch $HOME/.bash_profile
source $HOME/.bash_profile
PATH_INCLUDES_GO=$(grep "$HOME/go/bin" $HOME/.bash_profile)
if [ -z "$PATH_INCLUDES_GO" ]; then
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  echo "export GOPATH=$HOME/go" >> $HOME/.bash_profile
fi
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 5

source $HOME/.bash_profile

echo -e "\033[38;5;205mPackages updated, Go and Dependencies Inslalled. You can check your go version with = go version\033[0m"

sleep 7

echo -e "\033[35mDownloading the Celestia-Node\033[0m"

sleep 10

cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.15.0
make build
make install
make cel-key

sleep 5

echo -e "\033[35mLight Node is initializing\033[0m"
sleep 8
echo -e "\033[35mWith this step your wallet will be created!\033[0m"
sleep 5
echo -e "\033[31m⚠️⚠️⚠️Please do not forget to save your mnemonics!!!. If you dont save you can not access your wallet. You will have 100 second to save your mnemonics. After that script will continued!⚠️⚠️⚠️\033[0m"
echo -e "\033[31m⚠️⚠️⚠️ SAVE THE MNEMONICS⚠️⚠️⚠️\033[0m"
sleep 8
celestia light init --p2p.network mocha

sleep 100

echo -e "\033[35mStarting Service\033[0m"

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-lightd Light Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia light start --core.ip rpc-mocha.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia-mocha.com --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sleep 3

systemctl enable celestia-lightd
systemctl start celestia-lightd

echo -e "\033[35mLight Node Started Congrats!\033[0m"

sleep 3

echo -e "\033[35mSome Useful Command That You May Need For Service. Copy and Save!\033[0m"
sleep 3
echo -e "\033[35mCheck Your Logs:     sudo journalctl -u celestia-lightd -f --no-hostname -o cat\033[0m"
sleep 3
echo -e "\033[35mStop the Service:    sudo systemctl stop celestia-lightd\033[0m"
sleep 3
echo -e "\033[35mStart the Service:   sudo systemctl start celestia-lightd\033[0m"
sleep 3
echo -e "\033[35mRestart the Service: sudo systemctl restart celestia-lightd\033[0m"
sleep 20


echo -e "\033[35mNow we will Check Your Node ID. Please save it.\033[0m"

sleep 10

AUTH_TOKEN=$(celestia light auth admin --p2p.network mocha)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
	
	
sleep 20

echo -e "\033[38;5;205m⚠️⚠️⚠️Important NOTE: You need to back up the keys folder under the .celestia-light-mocha-4 folder with WinSCP or a tool with the same function. Your key and ID information is there. Be sure to back up this folder!\033[0m"
sleep 4

echo -e "\033[35mGood Luck My Modular Friend!\033[0m"

sleep 10

    ;;
  f)
    echo -e "\033[35mFull Node! Good Choice!\033[0m"
sleep 7	
echo -e "\033[38;5;205m⚠️Starting with Packages update and Dependencies Inslall⚠️\033[0m"
sleep 5

sudo apt update && apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential \
git make ncdu -y 

sleep 5

echo -e "\033[38;5;205m⚠️Installing GO⚠️\033[0m"

sleep 10

cd $HOME
curl -Ls https://go.dev/dl/go1.21.1.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
touch $HOME/.bash_profile
source $HOME/.bash_profile
PATH_INCLUDES_GO=$(grep "$HOME/go/bin" $HOME/.bash_profile)
if [ -z "$PATH_INCLUDES_GO" ]; then
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  echo "export GOPATH=$HOME/go" >> $HOME/.bash_profile
fi
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 5

source $HOME/.bash_profile

echo -e "\033[38;5;205mPackages updated, Go and Dependencies Inslalled. You can check your go version with = go version\033[0m"

sleep 7

echo -e "\033[35mDownloading the Celestia-Node\033[0m"

sleep 10

cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.15.0
make build
make install
make cel-key

sleep 5

echo -e "\033[35mFull Node is initializing\033[0m"
sleep 8
echo -e "\033[31mWith this step your wallet will be created!\033[0m"
sleep 5
echo -e "\033[31m⚠️⚠️⚠️Please do not forget to save your mnemonics!!!. If you dont save you can not access your wallet. You will have 100 second to save your mnemonics. After that script will continued!⚠️⚠️⚠️\033[0m"
echo -e "\033[31m⚠️⚠️⚠️ SAVE THE MNEMONICS⚠️⚠️⚠️\033[0m"
sleep 8
celestia full init --p2p.network mocha

sleep 100

echo -e "\033[35mStarting Service\033[0m"

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-fulld.service
[Unit]
Description=celestia-fulld Full Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia full start --core.ip rpc-mocha.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia-mocha.com --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sleep 3

systemctl enable celestia-fulld
systemctl start celestia-fulld

echo -e "\033[35mFull Node Started Congrats!\033[0m"

sleep 3

echo -e "\033[35mSome Useful Command That You May Need For Service. Copy and Save!\033[0m"
sleep 3
echo -e "\033[35mCheck Your Logs:     sudo journalctl -u celestia-fulld -f --no-hostname -o cat\033[0m"
sleep 3
echo -e "\033[35mStop the Service:    sudo systemctl stop celestia-fulld\033[0m"
sleep 3
echo -e "\033[35mStart the Service:   sudo systemctl start celestia-fulld\033[0m"
sleep 3
echo -e "\033[35mRestart the Service: sudo systemctl restart celestia-fulld\033[0m"
sleep 20

echo -e "\033[35mNow we will Check Your Node ID. Please save it.\033[0m"

sleep 5

AUTH_TOKEN=$(celestia full auth admin --p2p.network mocha)


curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

	 
sleep 20

echo -e "\033[38;5;205m⚠️⚠️⚠️Important NOTE: You need to back up the keys folder under the .celestia-full-mocha-4 folder with WinSCP or a tool with the same function. Your key information is there. Be sure to back up this folder!\033[0m"
sleep 4

echo -e "\033[35mGood Luck My Modular Friend!\033[0m"

sleep 10	
	
    ;;
  b)
    echo -e "\033[35mBridge Node! Good Choice!\033[0m"
sleep 7	
prompt() {
  read -p "$1: " val
  echo $val
}

echo -e "\033[38;5;205m⚠️Starting with Packages update and Dependencies Inslall⚠️\033[0m"
sleep 5

sudo apt update && apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential \
git make ncdu -y 

sleep 5

echo -e "\033[38;5;205m⚠️Installing GO⚠️\033[0m"

sleep 10

cd $HOME
curl -Ls https://go.dev/dl/go1.21.1.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
touch $HOME/.bash_profile
source $HOME/.bash_profile
PATH_INCLUDES_GO=$(grep "$HOME/go/bin" $HOME/.bash_profile)
if [ -z "$PATH_INCLUDES_GO" ]; then
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  echo "export GOPATH=$HOME/go" >> $HOME/.bash_profile
fi
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 5

source $HOME/.bash_profile

echo -e "\033[38;5;205mPackages updated, Go and Dependencies Inslalled. You can check your go version with = go version\033[0m"

sleep 5

echo -e "\033[35mSetting up celestia-node\033[0m"

sleep 5

cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.15.0
make build
make install
make cel-key

sleep 5

echo -e "\033[35mBridge Node is initializing\033[0m"
sleep 8
echo -e "\033[31mWith this step your wallet will be created!\033[0m"
sleep 5
echo -e "\033[31m⚠️⚠️⚠️Please do not forget to save your mnemonics!!!. If you dont save you can not access your wallet. You will have 100 second to save your mnemonics. After that script will continued!⚠️⚠️⚠️\033[0m"
sleep 5
echo -e "\033[31m⚠️⚠️⚠️ SAVE THE MNEMONICS⚠️⚠️⚠️\033[0m"
sleep 3
celestia bridge init --p2p.network mocha

sleep 100

echo -e "\033[35mStarting Service for Bridge Node\033[0m"
sleep 5
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-bridge.service
[Unit]
Description=celestia-bridge daemon
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia bridge start --core.ip rpc-mocha.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia-mocha.com --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sleep 3

sudo systemctl enable celestia-bridge
sudo systemctl start celestia-bridge

echo -e "\033[35mBridge Node Started. Congrats!\033[0m"

sleep 5

echo -e "\033[35mSome Useful Command That You May Need For Bridge Node Service. Copy and Save!\033[0m"
sleep 3
echo -e "\033[35mCheck Your Logs:     sudo journalctl -u celestia-bridge -f --no-hostname -o cat\033[0m"
sleep 3
echo -e "\033[35mStop the Service:    sudo systemctl stop celestia-bridge\033[0m"
sleep 3
echo -e "\033[35mStart the Service:   sudo systemctl start celestia-bridge\033[0m"
sleep 3
echo -e "\033[35mRestart the Service: sudo systemctl restart celestia-bridge\033[0m"
sleep 20

echo -e "\033[35mNow we will Check Your Node ID. Please save it.\033[0m"

sleep 7

AUTH_TOKEN=$(celestia bridge auth admin --p2p.network mocha)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
	 
sleep 20

echo -e "\033[38;5;205m⚠️⚠️⚠️Important NOTE: You need to back up the keys folder under the .celestia-bridge-mocha-4 folder with WinSCP or a tool with the same function. Your key and ID information is there. Be sure to back up this folder!\033[0m"
sleep 10

echo -e "\033[38;5;205mNOTE: As the network moves forward, it may take a little more time to synchronize to the network. If you want to continue without waiting, you can use the snapshot provided by the Itrocket team. For details: https://itrocket.net/services/testnet/celestia/ \033[0m"

echo -e "\033[35mGood Luck My Modular Friend!\033[0m"

sleep 10
    ;;

  v)
    echo -e "\033[35mValidator Node! Good Choice!\033[0m"   
sleep 7

prompt() {
  read -p "$1: " val
  echo $val
}

echo -e "\033[38;5;205m⚠️Starting with Packages update and Dependencies Inslall⚠️\033[0m"
sleep 5

sudo apt update && apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential \
git make ncdu -y 

sleep 5

echo -e "\033[38;5;205m⚠️Installing GO⚠️\033[0m"

sleep 10

cd $HOME
curl -Ls https://go.dev/dl/go1.21.1.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
touch $HOME/.bash_profile
source $HOME/.bash_profile
PATH_INCLUDES_GO=$(grep "$HOME/go/bin" $HOME/.bash_profile)
if [ -z "$PATH_INCLUDES_GO" ]; then
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  echo "export GOPATH=$HOME/go" >> $HOME/.bash_profile
fi
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 5

source $HOME/.bash_profile

echo -e "\033[38;5;205mPackages updated, Go and Dependencies Inslalled. You can check your go version with = go version\033[0m"

sleep 7

echo -e "\033[35mSetting Up Celestia-app\033[0m"

sleep 5

cd $HOME 
rm -rf celestia-app 
git clone https://github.com/celestiaorg/celestia-app.git 
cd celestia-app/ 
APP_VERSION=v1.11.0
git checkout tags/$APP_VERSION -b $APP_VERSION
make install

sleep 8

echo -e "\033[35mSetting Up P2P Network\033[0m"

sleep 5

cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git

sleep 5

echo -e "\033[35mInitializing the Celestia-app\033[0m"

sleep 5

node_name=$(prompt "Enter your node name")
celestia-appd init $node_name --chain-id mocha-4

sleep 8

celestia-appd download-genesis mocha-4
seeds="ee9f90974f85c59d3861fc7f7edb10894f6ac3c8@seed-mocha.pops.one:26656,5d0bf034d6e6a8b5ee31a2f42f753f1107b3a00e@celestia-testnet-seed.itrocket.net:11656, 3f472746f46493309650e5a033076689996c8881@celestia-testnet.rpc.kjnodes.com:12059"
sed -i "s/^seeds *=.*/seeds = \"$seeds\"/;" $HOME/.celestia-app/config/config.toml

PRUNING="nothing"
sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.celestia-app/config/app.toml

celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app

sleep 5

echo -e "\033[35mStarting celestia-appd Service\033[0m"

sleep 3

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-appd.service
[Unit]
Description=celestia-appd daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/celestia-appd start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sleep 3

sudo systemctl enable celestia-appd
sudo systemctl start celestia-appd

sleep 3


echo -e "\033[35mDownloading Snapshot for Quick Sync. Please wait\033[0m"
sleep 20
sudo systemctl stop celestia-appd
cp $HOME/.celestia-app/data/priv_validator_state.json $HOME/.celestia-app/priv_validator_state.json.backup
rm -rf $HOME/.celestia-app/data

sudo apt-get install lz4

curl https://testnet-files.itrocket.net/celestia/snap_celestia.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.celestia-app
mv $HOME/.celestia-app/priv_validator_state.json.backup $HOME/.celestia-app/data/priv_validator_state.json
sleep 20

curl -Ls https://snapshots.kjnodes.com/celestia-testnet/addrbook.json > $HOME/.celestia-app/config/addrbook.json
sudo systemctl restart celestia-appd 
sleep 5

echo -e "\033[35mSnapshot Downloaded. Service Restarted.\033[0m"

sleep 3

echo -e "\033[35mCongrats!! Your node started!\033[0m"
sleep 3
echo -e "\033[35mSome Useful Command That You May Need For celestia-app Service. Copy and Save!\033[0m"
sleep 3
echo -e "\033[35mCheck Your Logs:       sudo journalctl -u celestia-appd -f --no-hostname -o cat\033[0m"
sleep 3
echo -e "\033[35mStop the Service:      sudo systemctl stop celestia-appd\033[0m"
sleep 3
echo -e "\033[35mStart the Service:     sudo systemctl start celestia-appd\033[0m"
sleep 3
echo -e "\033[35mRestart the Service:   sudo systemctl restart celestia-appd\033[0m"
sleep 10

echo -e "\033[31m⚠️⚠️⚠️Lets create a wallet! Please do not forget to save your mnemonics!!!. If you dont save you can not access your wallet. After creating wallet, you will have 100 second to save your mnemonics. After that script will continued!⚠️⚠️⚠️\033[0m"
sleep 3
echo -e "\033[31m⚠️ Before creating your validator do not forget to top up your wallet with some testnet coin! ⚠️\033[0m"
sleep 3
echo -e "\033[31m⚠️⚠️⚠️ SAVE THE MNEMONICS⚠️⚠️⚠️\033[0m"
sleep 17

wallet_name=$(prompt "Enter your wallet name")
celestia-appd keys add $wallet_name

sleep 100

echo -e "\033[38;5;205mWith this script we automaticly check if your node fully synced. After synced you can go on with creating your validator. The script will check sync status every 60 seconds and will print the status.\033[0m"

while true
do

    sync_status=$(curl -s localhost:26657/status | jq '.result | .sync_info | .catching_up')
        if [ "$sync_status" = "false" ]; then
        echo "Your node is synced with the mocha network."
            sleep 5
            echo "Your node is now synced with the mocha network. Proceed with validator creation."
            sleep 5
            echo "Stop the script with ctrl C and edit the following command with your information to create your validator!"
            sleep 10
            echo -e "\033[38;5;205mcelestia-appd tx staking create-validator --amount=10000000utia --pubkey=$(celestia-appd tendermint show-validator) --moniker=$moniker --chain-id=mocha-4 --commission-rate=0.10 --commission-max-rate=0.20 --commission-max-change-rate=0.1 --min-self-delegation=1 --identity=KeyBaseID --details=details --website=Yourwebsite --security-contact=contactdetails --from=$wallet_name\033[0m"
		sleep 20

        else
       echo "Your node is not synced with the mocha network. Waiting for sync to complete..."
           sleep 60
        fi
done

    ;;  
  *)
    echo -e "\033[35mInvalid option. Please enter either l, f, b or v.\033[0m"
    ;;
esac
