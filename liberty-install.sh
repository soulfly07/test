#!/bin/bash

# Variables
INSTALL_DIR="$HOME/liberty"
GENESIS_URL="https://github.com/LibertyProject-chain/Liberty-Project-testnet-phase-2/releases/download/v0.23/genesis.json"
GETH_URL="https://github.com/LibertyProject-chain/Liberty-Project-testnet-phase-2/releases/download/v0.23/geth-linux-amd64"

# Step 1: Create installation directory
echo "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# Step 2: Download Geth binary and make it executable
echo "Downloading Geth binary..."
curl -L "$GETH_URL" -o /usr/local/bin/geth
echo "Making Geth binary executable..."
sudo chmod +x /usr/local/bin/geth

# Step 3: Download Genesis file
echo "Downloading Genesis file..."
curl -L "$GENESIS_URL" -o "$INSTALL_DIR/genesis.json"

# Step 4: Initialize the node with Genesis file
echo "Initializing node with Genesis file..."
geth --datadir "$INSTALL_DIR" init "$INSTALL_DIR/genesis.json"

# Step 5: Prompt for miner address
read -p "Enter miner address: " MINER_ADDRESS

# Step 6: Create systemd service
echo "Creating systemd service for Liberty node..."
sudo tee /etc/systemd/system/liberty-node.service > /dev/null <<EOF
[Unit]
Description=Liberty Node
After=network.target

[Service]
User=$USER
Restart=on-failure
RestartSec=10
ExecStart=/usr/local/bin/geth --datadir $INSTALL_DIR \\
--networkid 21102 \\
--port 40404 \\
--http.api debug,web3,eth,txpool,net \\
--mine \\
--miner.threads 1 \\
--miner.etherbase $MINER_ADDRESS \\
--gcmode archive \\
--bootnodes "enode://8b7cf2ff6d30e7fe7f1b8bfd67193844504144cb002f1a369326d8cd16227f2c2a0a73ee0e658dac2663b92e1af7e2fbae8a46388dfd5db602f704ee56ca8d57@94.142.138.78:40404"
LimitNOFILE=4096

[Install]
WantedBy=default.target
EOF

# Step 7: Reload systemd and start Liberty node
echo "Reloading systemd, enabling and starting Liberty node service..."
sudo systemctl daemon-reload
sudo systemctl enable liberty-node
sudo systemctl start liberty-node

# Step 8: Add peers to the node
echo "Adding peers to the Liberty node..."
sleep 5
geth attach --datadir "$INSTALL_DIR" <<EOF
admin.addPeer("enode://94f8c93ac23c2cb11fbf1fd79622947f3f9ff15cf2f3cf0efb5e459e6f8e41b1abc4754ad0198ac3255de9919738b3a0063728026ab360a15b93cbda7342a239@136.35.64.48:62476")
admin.addPeer("enode://5193fb7585cc8456aa124dae78fbccb83d32bc942ca52620f901664c20be0a94d2c0681eb95157c91b7595ca7c5f84aed1ac4016967fa69994b2cb1e494aac4a@150.136.233.131:54956")
admin.addPeer("enode://c6058fbe81a3fbb74acd4de6c9f62195ef3d0f866a8c4f59ac0c13474752af2ff88b39ab46aeda3146901f1759efd0f31f82d66329dd9428b366f48806969eec@164.92.115.251:39038")
admin.addPeer("enode://c01f848098bf651228b3eb74a44c8bb5b22d7ecdefc5815daf1b92de69f598245ad877063f2684aaa348de3e9988e81a6c1b7918eeb99805a0823fed0f7686d9@82.64.153.69:47424")
admin.addPeer("enode://73b19fa8772800d603d1275eb073785dd2d09af366a5d894a918e7a1cd8dade2f2e38eba198b951a67a1f311b0f8d25450340a9475366a8a7401d234c5f3bd12@149.86.35.185:51699")
admin.addPeer("enode://a23dc4c6c9be8853cc27fed4d38d8ec494a6c8fb1f44430c27c2374ad1639a1a718269aa93c0fd6c6b0e19b3ca2320ca8f3aa6affc08570d125ef689f980fd73@158.101.111.98:56682")
admin.addPeer("enode://03db4c7d90a6ad1baa8707126ad2e95d279155da6b2e0430e77fedee79f7f38748bd1fe1aac4d9f1fdbbd4148a410f5d5b43aa8560693c1fcd18833e53eaaa1a@111.51.90.11:3895")
admin.addPeer("enode://cb08c06f9733cb79b4e57528b1b571a3704aa967d69241b65194c7bc54b63362d17f900da594807f420e7b7e08db1130755310404e9221040261856bcdec6684@91.211.6.85:42692")
admin.addPeer("enode://7b93e668c4bddca45bdaf9e9833f97b2e76aacbbe4e8f2ae341a0ec2cddec4bfaef7a8ffae2cab658e44af5bc94408691b987a9b3e4868529304bb626fee030e@91.211.6.85:34774")
admin.addPeer("enode://3a4e8afc4b8d9cb19b587c9777998cb7030c075b7e9ccae73230949a3b7bcb20a54357a3b7904dc4d58ad0995a01607eb39ca53fc1408a1d7f4296ede3eca3c7@136.35.64.48:44780")
admin.addPeer("enode://921b698c4705f3370a1f7189c42bb0fdaac607718eddfee751af8607fec96c31207bd21bffaadc5c6355ee136cace8e117abee4087db496e6450300e2a45f4d4@136.35.64.48:57796")
admin.addPeer("enode://29bcc16e9f436a8591c1860eaaa7e3305dcfced6445555c915fb170156352220c0af65e6c7e80aac511fe69d4c78f20fb92096d77cafa3299ba9e3726a1d4e27@132.145.147.2:41244")
admin.addPeer("enode://1c008bdf9fe81a1a98440fb36f704ca40afcefb36500d9332ac328b33649e762596241ef2e06cb72102c4a15e89f7c5e7592e55c7839b4a7e1d3dba013c0fdeb@91.192.23.146:40404")
admin.addPeer("enode://5a69abda0bdeda0a59c624f0e43c6b884f382721b1c52aeb9f7d745011bf638194d87af8c73b9a411893a292033e6e5c3cd2fc0d7b3147d7515d738449ad9f64@194.147.149.162:40404")
admin.addPeer("enode://74ac4c68d7e32f6758dac6767bd4fec9b459272ae57dafad85c4d0e8739e07b3741e06b316b8f5d648fbc5dc393858e5b94412eecaba9ad0a5365e01ee86116d@91.211.6.85:2991")
admin.addPeer("enode://94f8c93ac23c2cb11fbf1fd79622947f3f9ff15cf2f3cf0efb5e459e6f8e41b1abc4754ad0198ac3255de9919738b3a0063728026ab360a15b93cbda7342a239@136.35.64.48:62476")
admin.addPeer("enode://5193fb7585cc8456aa124dae78fbccb83d32bc942ca52620f901664c20be0a94d2c0681eb95157c91b7595ca7c5f84aed1ac4016967fa69994b2cb1e494aac4a@150.136.233.131:54956")
admin.addPeer("enode://c6058fbe81a3fbb74acd4de6c9f62195ef3d0f866a8c4f59ac0c13474752af2ff88b39ab46aeda3146901f1759efd0f31f82d66329dd9428b366f48806969eec@164.92.115.251:39038")
admin.addPeer("enode://c01f848098bf651228b3eb74a44c8bb5b22d7ecdefc5815daf1b92de69f598245ad877063f2684aaa348de3e9988e81a6c1b7918eeb99805a0823fed0f7686d9@82.64.153.69:47424")
admin.addPeer("enode://73b19fa8772800d603d1275eb073785dd2d09af366a5d894a918e7a1cd8dade2f2e38eba198b951a67a1f311b0f8d25450340a9475366a8a7401d234c5f3bd12@149.86.35.185:51699")
admin.addPeer("enode://a23dc4c6c9be8853cc27fed4d38d8ec494a6c8fb1f44430c27c2374ad1639a1a718269aa93c0fd6c6b0e19b3ca2320ca8f3aa6affc08570d125ef689f980fd73@158.101.111.98:56682")
admin.addPeer("enode://03db4c7d90a6ad1baa8707126ad2e95d279155da6b2e0430e77fedee79f7f38748bd1fe1aac4d9f1fdbbd4148a410f5d5b43aa8560693c1fcd18833e53eaaa1a@111.51.90.11:3895")
admin.addPeer("enode://cb08c06f9733cb79b4e57528b1b571a3704aa967d69241b65194c7bc54b63362d17f900da594807f420e7b7e08db1130755310404e9221040261856bcdec6684@91.211.6.85:42692")
admin.addPeer("enode://7b93e668c4bddca45bdaf9e9833f97b2e76aacbbe4e8f2ae341a0ec2cddec4bfaef7a8ffae2cab658e44af5bc94408691b987a9b3e4868529304bb626fee030e@91.211.6.85:34774")
admin.addPeer("enode://3a4e8afc4b8d9cb19b587c9777998cb7030c075b7e9ccae73230949a3b7bcb20a54357a3b7904dc4d58ad0995a01607eb39ca53fc1408a1d7f4296ede3eca3c7@136.35.64.48:44780")
admin.addPeer("enode://921b698c4705f3370a1f7189c42bb0fdaac607718eddfee751af8607fec96c31207bd21bffaadc5c6355ee136cace8e117abee4087db496e6450300e2a45f4d4@136.35.64.48:57796")
admin.addPeer("enode://29bcc16e9f436a8591c1860eaaa7e3305dcfced6445555c915fb170156352220c0af65e6c7e80aac511fe69d4c78f20fb92096d77cafa3299ba9e3726a1d4e27@132.145.147.2:41244")
admin.addPeer("enode://1c008bdf9fe81a1a98440fb36f704ca40afcefb36500d9332ac328b33649e762596241ef2e06cb72102c4a15e89f7c5e7592e55c7839b4a7e1d3dba013c0fdeb@91.192.23.146:40404")
admin.addPeer("enode://5a69abda0bdeda0a59c624f0e43c6b884f382721b1c52aeb9f7d745011bf638194d87af8c73b9a411893a292033e6e5c3cd2fc0d7b3147d7515d738449ad9f64@194.147.149.162:40404")
admin.addPeer("enode://74ac4c68d7e32f6758dac6767bd4fec9b459272ae57dafad85c4d0e8739e07b3741e06b316b8f5d648fbc5dc393858e5b94412eecaba9ad0a5365e01ee86116d@91.211.6.85:2991")
exit
EOF

echo "Liberty node setup is complete. Peers have been added successfully."
echo "RUN LOG"
echo "journalctl -u liberty-node -f --no-hostname -o cat -n 100"
