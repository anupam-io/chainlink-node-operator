## Resources
 - https://docs.chain.link/docs/running-a-chainlink-node
 - https://docs.chain.link/docs/fulfilling-requests

## Setting up the `.env` file
    mkdir ~/.chainlink-kovan
    touch .env

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

## Set the local `postgres` DATABASE_URL Config
    sudo -i -u postgres
    psql
    ALTER USER postgres PASSWORD '12345678'

    Postges setup:
        username: postgres
        password: 12345678
        server: 127.0.0.1
        port: 5432
        database: postgres

    echo "DATABASE_URL=postgresql://postgres:12345678@127.0.0.1:5432/postgres" >> ~/.chainlink-kovan/.env
    echo "DATABASE_TIMEOUT=0" >> ~/.chainlink-kovan/.env

## Start the Chainlink Node
    cd ~/.chainlink-kovan 
    
    docker run --name chainlink-kovan --network host -p 6688:6688 -v ~/.chainlink-kovan:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.3 local n

    docker system prune #remove stopped images
    docker network ls #check if `host` is showing here.
    Password: anupam007JAIHO
    Account: 0x777C8cCaF12Bd4b11aB39B69c02D2dd00BF8a0EF


    https://localhost:6688

    Deploy one `Oracle.sol`.
    Give permission to your node.
    Deploy `ATestnetConsumer.sol`
    Query for data.

    Oracle: https://kovan.etherscan.io/address/0x63a7E202B1e0d76C576841fB91E6dB0D03D95a0F#writeContract
    ATestnetConsumer: https://kovan.etherscan.io/address/0x3D07b397734D638906db75859eb97949C9402f72#contracts
    


