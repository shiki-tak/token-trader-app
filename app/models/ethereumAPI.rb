# TODO: Refactoring
class EthereumAPI
  PATH = "#{Dir.pwd}/contracts/ERC20Token.sol"
  require "#{Dir.pwd}/app/models/hasheduser.rb"
  require "json"

  def deployERC20Token(name, symbol, totalTokens)
    # TODO: Error handling when executing Smart Contract
    # owner_address = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78" # office mac book air
    owner_address = "0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b" # private mac book air
    $client = Ethereum::HttpClient.new('http://localhost:8545')
    $client.personal_unlock_account(owner_address, "pass0")
    @contract = Ethereum::Contract.create(file: PATH, client: $client)
    # smart contractのデプロイ時にtotalTokensの型がfloatではエラーが起きるためinteger型にキャストした
    @address = @contract.deploy_and_wait(owner_address, name, symbol, totalTokens.to_i)
    puts @contract.call.balance_of(owner_address)
  end

  # execute trade
  def executeTransfer(maker_address, from_username, amount, password)
    @contract = Ethereum::Contract.create(file: PATH, client: $client)
    $client.personal_unlock_account(from_username, password)
    @address = @contract.transact_and_wait.transfer_from(maker_address, from_username, amount)
  end

  def createGethAccount(password)
    $client = Ethereum::HttpClient.new('http://localhost:8545')
    createAccount = $client.personal_new_account(password)
    createAccountAtJSON = JSON.generate(createAccount)
    createAccountResult = JSON.parse(createAccountAtJSON)
    etherAccount = createAccountResult['result'].to_s
    $client.personal_unlock_account(etherAccount, password)
    puts "createGethAccount Result: #{etherAccount}"
    return etherAccount
  end
end
