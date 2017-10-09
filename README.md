# README

* gethの起動コマンド
```
geth --networkid 4649 --nodiscover --maxpeers 0 --datadir /Users/shikitakahashi/workspace/eth/data_testnet --mine --minerthreads 1 --rpc --rpcaddr "0.0.0.0" --rport 8545 --rpccorsdomain "*" --rpcapi "admin, db, eth, debug, miner, net, shh, txpool, personal, web3" 2>> /Users/shikitakahashi/workspace/eth/data_testnet/geth.log
```

* library
EthWorks/ethereum.rb
(https://github.com/EthWorks/ethereum.rb.git)

* Tokenの仕様
本システムのトークンはEthereumが提唱しているトークンの標準仕様「ERC20」に準拠しています。

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
