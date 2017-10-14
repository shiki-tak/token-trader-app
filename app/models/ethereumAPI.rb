# TODO: Refactoring
class EthereumAPI
  PATH = "#{Dir.pwd}/contracts/ERC20Token.sol"
  require "#{Dir.pwd}/app/models/hasheduser.rb"
  require "json"

  def set_client(owner_address, ether_account_password)
    # TODO: Error handling when executing Smart Contract
    # ISSUE: gethを入れて最初に作ったアカウント(eth.accounts[0], "pass0")ではコントラクトが実行できるが
    #        sign_upで登録したuserでは"IOError - account is locked:"のエラーが発生して
    #        コントラクトが実行できない。

    # owner_address = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78" # office mac book air
    owner_address = "0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b" # private mac book air
    ether_account_password = "pass0"
    @client = Ethereum::HttpClient.new('http://localhost:8545')
    @client.personal_unlock_account(owner_address, ether_account_password)
    @contract = Ethereum::Contract.create(file: PATH, client: @client)
  end

  # Send ether for gas to users registered for demonstration
  def sendEtherForGas
  end

  def deployERC20Token(owner_address, ether_account_password, name, symbol, totalTokens)
    set_client(owner_address, ether_account_password)
    # smart contractのデプロイ時にtotalTokensの型がfloatではエラーが起きるためinteger型にキャストした
    @address = @contract.deploy_and_wait(owner_address, name, symbol, totalTokens.to_i)
    puts @contract.call.balance_of(owner_address)
  end

  # execute trade
  def executeTransfer(maker_address, to_username, amount, password)
    @address = @contract.transact_and_wait.transfer_from(maker_address, to_username, amount)
  end

  def createGethAccount(password)
    @client = Ethereum::HttpClient.new('http://localhost:8545')
    createAccount = @client.personal_new_account(password)
    createAccountAtJSON = JSON.generate(createAccount)
    createAccountResult = JSON.parse(createAccountAtJSON)
    etherAccount = createAccountResult['result'].to_s
    @client.personal_unlock_account(etherAccount, password)
    puts "createGethAccount Result: #{etherAccount}"
    return etherAccount
  end
end
