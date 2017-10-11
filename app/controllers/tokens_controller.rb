class TokensController < ApplicationController
  before_action :authenticate_user!

  PATH = "#{Dir.pwd}/contracts/Token.sol"

  def index
    if user_signed_in?
      @tokens = Token.all
    else
      redirect_to new_user_session_path
    end

  end

  def new
    @token = Token.new
  end

  def create
    @token = Token.new(tokens_params)
    @token.owner_id = current_user.username
    @token.balanceTokens = @token.totalTokens
    if @token.save
      owner_address = "0xd4232bdbc4cdbdc9d131103de55b9a2b68d45c78"
      $client = Ethereum::HttpClient.new('http://localhost:8545')
      $client.personal_unlock_account(owner_address, "pass0")
      @contract = Ethereum::Contract.create(file: PATH, client: $client)
      # smart contractのデプロイ時にtotalTokensの型がdecimalではエラーが起きるためinteger型にキャストした
      @address = @contract.deploy_and_wait(owner_address, @token.name, @token.symbol, @token.totalTokens.to_i)
      puts @contract.call.balance_of(owner_address)
      redirect_to tokens_path, notice: "Success Create Token!"
    else
      render 'new'
    end
  end

  private
    def tokens_params
      params.require(:token).permit(:name, :symbol, :totalTokens, :balanceTokens, :owner_id)
    end
end
