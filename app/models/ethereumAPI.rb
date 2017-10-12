class EthereumAPI
  PATH = "#{Dir.pwd}/contracts/ERC20Token.sol"

  def deployERC20Token(name, symbol, totalTokens)
    owner_address = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78"
    $client = Ethereum::HttpClient.new('http://localhost:8545')
    $client.personal_unlock_account(owner_address, "pass0")
    @contract = Ethereum::Contract.create(file: PATH, client: $client)
    # smart contractのデプロイ時にtotalTokensの型がfloatではエラーが起きるためinteger型にキャストした
    @address = @contract.deploy_and_wait(owner_address, name, symbol, totalTokens.to_i)
    puts @contract.call.balance_of(owner_address)
  end
end
