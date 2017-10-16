# TODO: Refactoring
class EthereumAPI
  require "#{Dir.pwd}/app/models/hasheduser.rb"
  require "json"

  # TODO: Setting constants
  ETHEREUM_ADDRESS = "http://localhost:8545"
  PATH = "#{Dir.pwd}/contracts/ERC20Token.sol"
  SUPPLIER_ADDRESS = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78" # office mac book air
  # SUPPLIER_ADDRESS = "0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b" # private mac book air
  SUPPLIER_PASSWORD = "pass0"
  SWAP_TRADE_ABI = '[{constant: true, inputs: [], name: "name", outputs: [{name: "", type: "string" }], payable: false, stateMutability: "view", type: "function"}, { constant: false, inputs: [{ name: "_spender", type: "address" }, { name: "_amount", type: "uint256" }], name: "approve", outputs: [{ name: "success", type: "bool" }], payable: false, stateMutability: "nonpayable", type: "function"}, { constant: true, inputs: [], name: "totalSupply", outputs: [{ name: "totalSupply", type: "uint256" }], payable: false, stateMutability: "view", type: "function"}, { constant: false, inputs: [{ name: "_owner", type: "address" }, { name: "_to", type: "address" }, { name: "_amount", type: "uint256" }], name: "transferInternal", outputs: [{ name: "success", type: "bool" }], payable: false, stateMutability: "nonpayable", type: "function"}, { constant: false, inputs: [{ name: "_from", type: "address" }, { name: "_to", type: "address" }, { name: "_amount", type: "uint256" }], name: "transferFrom", outputs: [{ name: "success", type: "bool" }], payable: false, stateMutability: "nonpayable", type: "function"}, { constant: true, inputs: [], name: "floats", outputs: [{ name: "", type: "uint8" }], payable: false, stateMutability: "view", type: "function"}, { constant: true, inputs: [{ name: "_owner", type: "address" }], name: "balanceOf", outputs: [{ name: "balance", type: "uint256" }], payable: false, stateMutability: "view", type: "function"}, { constant: true, inputs: [], name: "owner", outputs: [{ name: "", type: "address" }], payable: false, stateMutability: "view", type: "function"}, { constant: true, inputs: [], name: "symbol", outputs: [{ name: "", type: "string" }], payable: false, stateMutability: "view", type: "function"}, { constant: false, inputs: [{ name: "_to", type: "address" }, { name: "_amount", type: "uint256" }], name: "transfer", outputs: [{ name: "success", type: "bool" }], payable: false, stateMutability: "nonpayable", type: "function"}, { constant: true, inputs: [{ name: "_owner", type: "address" }, { name: "_spender", type: "address" }], name: "allowance", outputs: [{ name: "remaining", type: "uint256" }], payable: false, stateMutability: "view", type: "function"}, { inputs: [{ name: "_owner", type: "address" }, { name: "_name", type: "string" }, { name: "_symbol", type: "string" }, { name: "_totalTokens", type: "uint256" }], payable: false, stateMutability: "nonpayable", type: "constructor"}, { anonymous: false, inputs: [{ indexed: true, name: "_from", type: "address" }, { indexed: true, name: "_to", type: "address" }, { indexed: false, name: "_value", type: "uint256" }], name: "Transfer", type: "event"}, { anonymous: false, inputs: [{ indexed: true, name: "_owner", type: "address" }, { indexed: true, name: "_spender", type: "address" }, { indexed: false, name: "_value", type: "uint256" }], name: "Approval", type: "event"}]'

  def set_client(owner_address, ether_account_password)
    # TODO: Error handling when executing Smart Contract
    @client = Ethereum::HttpClient.new(ETHEREUM_ADDRESS)
    @client.personal_unlock_account(owner_address, ether_account_password)
  end

  def deployERC20Token(owner_address, ether_account_password, name, symbol, totalTokens)
    set_client(owner_address, ether_account_password)
    # Exception handling
    begin
      @contract = Ethereum::Contract.create(file: PATH, client: @client)
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
  def executeTransfer(maker_address, to_username, amount, password)
    @contract = Ethereum::Contract.create(file: PATH, client: @client)
    @address = @contract.transact_and_wait.transfer_from(maker_address, to_username, amount)
    puts "Success Transfer!"
  end

  def createGethAccount(password)
    @client = Ethereum::HttpClient.new(ETHEREUM_ADDRESS)
    createAccount = @client.personal_new_account(password)
    createAccountAtJSON = JSON.generate(createAccount)
    createAccountResult = JSON.parse(createAccountAtJSON)
    etherAccount = createAccountResult['result'].to_s
    sendEtherForGas(etherAccount)
    @client.personal_unlock_account(etherAccount, password)
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
