class TokensController < ApplicationController

  PATH = "#{Dir.pwd}/contracts/Token.sol"

  def index
  end

  def new

  end

  def create
    @token = Token.new(token_params)
    owner_address = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78"
    $client.personal_unlock_account(owner_address, "pass0")
    @contract = Ethereum::Contract.create(file: PATH, client: $client)
    @address = @contract.deploy_and_wait(owner_address, @token.name, @token.symbol, @token.totalTokens)
    puts @contract.call.balance_of(owner_address)
    redirect_to issue_index_path
  end

  private
    def token_params
      params.require(:token).permit(:name, :symbol, :totalTokens)
    end
end
