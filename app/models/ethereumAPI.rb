# TODO: Refactoring
class EthereumAPI
  require "#{Dir.pwd}/app/models/hasheduser.rb"
  require "json"

  # TODO: Setting constants
  # TODO: IPCで接続に成功したらETHEREUM_ADDRESSの名前を変更する
  #      PATHの指定の仕方がイケてない...
  ETHEREUM_ADDRESS = "/Users/user1/eth/data_testnet/geth.ipc"
  ETHEREUM_TOKEN_PATH = "#{Dir.pwd}/contracts/ERC20Token.sol"
  SUPPLIER_ADDRESS = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78"
  SUPPLIER_PASSWORD = "pass0"
  ERC20TOKEN_ABI = '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_amount","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferInternal","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"floats","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_owner","type":"address"},{"name":"_name","type":"string"},{"name":"_symbol","type":"string"},{"name":"_totalTokens","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]'

  def set_client(owner_address, ether_account_password)
    # TODO: Error handling when executing Smart Contract
    @client = Ethereum::IpcClient.new(ETHEREUM_ADDRESS)
    @client.personal_unlock_account(owner_address, ether_account_password)
  end

  def deployERC20Token(owner_address, ether_account_password, name, symbol, totalTokens)
    set_client(owner_address, ether_account_password)
    # Exception handling
    begin
      @contract = Ethereum::Contract.create(file: ETHEREUM_TOKEN_PATH, client: @client)
      # ISSUE: 一度ロックがかかると解除できない ⇒ contractのdeployに失敗する
      # smart contractのデプロイ時にtotalTokensの型がfloatではエラーが起きるためinteger型にキャストした
      @address = @contract.deploy_and_wait(owner_address, name, symbol, totalTokens.to_i)
    rescue => e
      puts "Exception handling"
      puts e.message
      return "Error", false
    end
    puts "Success contract deploy!"
    puts "Contract address: #{@contract.address}"
    puts "Token Total Supply: #{@contract.call.balance_of(owner_address)}"
    return @contract.address, true
  end

  # execute trade
  def executeTransfer(maker_token_addr, taker_token_addr, maker_address, taker_address, maker_amount, taker_amount, ether_account_password)
    set_client(taker_address, ether_account_password)
    # trade token smart contract execute
    @maker_contract = Ethereum::Contract.create(file: ETHEREUM_TOKEN_PATH, client: @client, address: maker_token_addr, abi: ERC20TOKEN_ABI)
    @taker_contract =  Ethereum::Contract.create(file: ETHEREUM_TOKEN_PATH, client: @client, address: taker_token_addr, abi: ERC20TOKEN_ABI)
    # TODO: Fix to use send_transaction
    # ISSUE: RemixでSwapTrade.sol経由でERC20Token.solのtransferFromを実行しようとすると
    # 「callback contain no result Gas required exceeds limit: 3000000」のエラーが発生する
    #  →send_transactionを使ってtoken_addressを渡せない...
    begin
      # TODO: maker_token_amountとtaker_token_amountに分けてcontractを実行しないと、上手くいかない...しかし、一つにまとめたい
      @address = @maker_contract.transact_and_wait.transfer_from(maker_address, taker_address, maker_amount)
      @address = @taker_contract.transact_and_wait.transfer_from(taker_address, maker_address, taker_amount)
      puts "Success Transfer!"
      puts "Maker' balance"
      puts "Maker Token: #{@maker_contract.call.balance_of(maker_address)}"
      puts "Taker Token: #{@taker_contract.call.balance_of(maker_address)}"
      puts "Taker's balance"
      puts "Maker Token: #{@maker_contract.call.balance_of(taker_address)}"
      puts "Taker Token: #{@taker_contract.call.balance_of(taker_address)}"
    rescue => e
      puts "Exception handling"
      puts e.message
    end
  end

  def createGethAccount(password)
    @client = Ethereum::IpcClient.new(ETHEREUM_ADDRESS)
    createAccount = @client.personal_new_account(password)
    createAccountAtJSON = JSON.generate(createAccount)
    createAccountResult = JSON.parse(createAccountAtJSON)
    etherAccount = createAccountResult['result'].to_s
    sendEtherForGas(etherAccount)
    @client.personal_unlock_account(etherAccount, password, 0)
    puts "createGethAccount Result: #{etherAccount}"
    return etherAccount
  end

  # Send ether for gas to users registered for demonstration
  def sendEtherForGas(etherAccount)
    set_client(SUPPLIER_ADDRESS, SUPPLIER_PASSWORD)
    @client.eth_send_transaction({
      "from": SUPPLIER_ADDRESS,
      "to": etherAccount,
      "value": "0x3b9aca00"
      })
      puts "Success send ether from #{SUPPLIER_ADDRESS} to #{etherAccount}"
  end
end
