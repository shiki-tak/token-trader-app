class TopController < ApplicationController

  PATH = "#{Dir.pwd}/contracts/Greeting.sol"

  def index
    $client = Ethereum::HttpClient.new('http://localhost:8545')
    # $client.personal_unlock_account("0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b", "pass0")
    # $contract = Ethereum::Contract.create(file: PATH, client: $client)
    # $address = $contract.deploy_and_wait()
  end
end
