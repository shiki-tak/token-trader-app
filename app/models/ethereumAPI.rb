# TODO: Refactoring
class EthereumAPI
  PATH = "#{Dir.pwd}/contracts/ERC20Token.sol"
  require "#{Dir.pwd}/app/models/hasheduser.rb"
  require "json"
  # SUPPLIER_ADDRESS = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78" # office mac book air
  SUPPLIER_ADDRESS = "0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b" # private mac book air
  SUPPLIER_PASSWORD = "pass0"

  def set_client(owner_address, ether_account_password)
    # TODO: Error handling when executing Smart Contract
    @client = Ethereum::HttpClient.new('http://localhost:8545')
    @client.personal_unlock_account(owner_address, ether_account_password)
  end

  def deployERC20Token(owner_address, ether_account_password, name, symbol, totalTokens)
    set_client(owner_address, ether_account_password)
    @contract = Ethereum::Contract.create(file: PATH, client: @client)
    # ISSUE: 一度ロックがかかると解除できない ⇒ contractのdeployに失敗する
    # smart contractのデプロイ時にtotalTokensの型がfloatではエラーが起きるためinteger型にキャストした
    @address = @contract.deploy_and_wait(owner_address, name, symbol, totalTokens.to_i)
    puts @contract.call.balance_of(owner_address)
  end

  # execute trade
  def executeTransfer(maker_address, to_username, amount, password)
    @contract = Ethereum::Contract.create(file: PATH, client: @client)
    @address = @contract.transact_and_wait.transfer_from(maker_address, to_username, amount)
  end

  def createGethAccount(password)
    @client = Ethereum::HttpClient.new('http://localhost:8545')
    createAccount = @client.personal_new_account(password)
    createAccountAtJSON = JSON.generate(createAccount)
    createAccountResult = JSON.parse(createAccountAtJSON)
    etherAccount = createAccountResult['result'].to_s
    sendEtherForGas(etherAccount)
    @client.personal_unlock_account(etherAccount, password)
    @contract = Ethereum::Contract.create(file: PATH, client: @client)
    puts "createGethAccount Result: #{etherAccount}"
    return etherAccount
  end

  # Send ether for gas to users registered for demonstration
  def sendEtherForGas(etherAccount)
    set_client(SUPPLIER_ADDRESS, SUPPLIER_PASSWORD)
    @client.eth_send_transaction({
      "from": SUPPLIER_ADDRESS,
      "to": etherAccount,
      "value": "0x64"
      })
      puts "Success send ether from #{SUPPLIER_ADDRESS} to #{etherAccount}"
  end
end
