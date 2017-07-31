# PEC
Private Ethereum Chain

Create a private Ethereum chain

Create the Genesis block:
	Save a file called myGenesis.json with below content:
		
{
    "nonce": "0x0000000000000042",
    "timestamp": "0x0",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x0",
    "gasLimit": "0x8000000",
    "difficulty": "0x400",
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x3333333333333333333333333333333333333333",
    "alloc": {
    }
}


Use below command to init a private chain
geth --identity "yiduo" --genesis myGenesis.json --rpc --rpcport "8000" --rpccorsdomain "*" --datadir "C:\chains\VPSChain" --port "30303" --nodiscover --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "db,eth,net,web3" --autodag --networkid 1900 --nat "any" console

Below is the explain for the parameters:
--nodiscover other people cannot find your private chain 
--maxpeers n  the n can be 0,1,2… to set the peers number that can connect to your private
--rpc enable the RPC interface on your node.
--rpcapi “db,eth,net,web3”  set what API that are allowed to be accessed over RPC
--rpcport  “8080” set the geth port
--rpccorsdomain “*” this dictates what URLs can connect to your node in order to perform PRC client tasks.
--datadir “/workspace”  set the data directory that your private chain data will be stored in.
--port “30303”  set the “network listening port”, which you will use to connect with other peers manually

--identity  “yourId” set up an identity for your node
