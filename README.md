# Setting up a chainlink node, deploying an oracle, making a request in a smart contract

## Resources
 - https://docs.chain.link/docs/running-a-chainlink-node
 - https://docs.chain.link/docs/fulfilling-requests
 - https://docs.chain.link/docs/job-specifications#config

## Setting up the `.env` file
    mkdir ~/.chainlink-kovan
    touch .env

 - Put this inside your `~/.chainlink-kovan/.env` file:
```
ROOT=/chainlink
LOG_LEVEL=debug
ETH_CHAIN_ID=42
MIN_OUTGOING_CONFIRMATIONS=2
LINK_CONTRACT_ADDRESS=0xa36085F69e2889c224210F603D836748e7dC0088
CHAINLINK_TLS_PORT=0
SECURE_COOKIES=false
GAS_UPDATER_ENABLED=true
ALLOW_ORIGINS=*
ETH_URL=CHANGEME
```

## Set the local `postgres` DATABASE_URL Config
    sudo -i -u postgres
    psql
    ALTER USER postgres PASSWORD '12345678'

    Postges setup:
        username: postgres
        password: 12345678
        server: localhost
        port: 5432
        database: postgres

 - Add these to your `~/.chainlink-kovan/.env` file
```
DATABASE_URL=postgresql://postgres:12345678@127.0.0.1:5432/postgres
DATABASE_TIMEOUT=0
```

## Start the Chainlink Node
    cd ~/.chainlink-kovan 
    
    docker run --name chainlink-kovan --network host -p 6688:6688 -v ~/.chainlink-kovan:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.3 local n

    Visit: http://localhost:6688/

 - Stopping & deleting container:
```
    docker stop chainlink-kovan
    docker container rm chainlink-kovan
```

 - `docker network ls`: make sure host is there.

## How to run?
 - Assuming that you have successfully setup the chainlink node.
 - Add a new job from the NODE UI, with [job spec](https://docs.chain.link/docs/job-specifications#config) as:
```
{
  "initiators": [
    {
      "type": "RunLog",
      "params": { "address": "0x51DE85B0cD5B3684865ECfEedfBAF12777cd0Ff8" }
    }
  ],
  "tasks": [
    {
      "type": "HTTPGet",
      "confirmations": 0,
      "params": { "get": "https://bitstamp.net/api/ticker/" }
    },
    {
      "type": "JSONParse",
      "params": { "path": [ "last" ] }
    },
    {
      "type": "Multiply",
      "params": { "times": 100 }
    },
    { "type": "EthUint256" },
    { "type": "EthTx" }
  ],
  "startAt": "2020-02-09T15:13:03Z",
  "endAt": null,
  "minPayment": "1000000000000000000"
}
```

 - `truffle compile`
 - `truffle migrate --reset --network kovan`
 - `truffle verify Oracle ATestnetConsumer --network kovan --license MIT`
 - `truffle exec scripts/1_add_permission.js --network kovan`
 - `truffle exec scripts/2_request.js --network kovan`
 - `truffle exec scripts/3_fund_link.js --network kovan`
 - `truffle exec scripts/4_request.js --network kovan`
 - `truffle exec scripts/5_read_val.js --network kovan`

 - `node main.js`: Check postgres connection & NODE funds 

## Deployed contracts
 - [Oracle.sol](https://kovan.etherscan.io/address/0x63a7E202B1e0d76C576841fB91E6dB0D03D95a0F)
 - [ATestnetConsumer.sol](https://kovan.etherscan.io/address/0x3D07b397734D638906db75859eb97949C9402f72)