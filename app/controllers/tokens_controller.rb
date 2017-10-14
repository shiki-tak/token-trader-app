class TokensController < ApplicationController
  require "#{Dir.pwd}/app/models/EthereumAPI.rb"
  before_action :authenticate_user!

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
    @hasheduser = Hasheduser.find(current_user.id)
    @token.owner_id = @hasheduser.ether_account
    @token.balanceTokens = @token.totalTokens
    if @token.save
      # execute smart contract
      smartContract = EthereumAPI.new()
      ether_account_password = @hasheduser.ether_account_password
      smartContract.deployERC20Token(@token.owner_id, ether_account_password, @token.name, @token.symbol, @token.totalTokens.to_i)
      redirect_to tokens_path, notice: "Success Create Token!"
    else
      render 'new'
    end
  end

  private
    def tokens_params
      params.require(:token).permit(:name, :symbol, :totalTokens, :balanceTokens, :owner_id).to_h
    end
end
