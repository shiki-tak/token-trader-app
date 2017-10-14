class TradesController < ApplicationController
  require "#{Dir.pwd}/app/models/EthereumAPI.rb"
  before_action :set_trade, only: [:transfer, :destroy]

  def index
    @trades = Trade.all
    @tokens = Token.new
    @trade = Trade.new
    @trade_amount = Trade.new
    @hasheduser = Hasheduser.find(current_user.id)
  end

  def new
  end

  def create
    @trade = Trade.new(trade_params)
    if @trade.from_token_name == @trade.to_token_name
      redirect_to trades_path, notice: "Token types are the same!"
    else
      @trade.from_token_name =  Token.find(@trade.from_token_name.to_i).symbol
      @trade.to_token_name =  Token.find(@trade.to_token_name.to_i).symbol
      @trade.to_token_amount = @trade.price * @trade.from_token_amount
      @hasheduser = Hasheduser.find(current_user.id)
      @trade.maker_address = @hasheduser.ether_account
      if @trade.save
        redirect_to trades_path, notice: "Success Sale's Info Set!"
      else
        render 'new'
      end
    end
  end

  def transfer
    # execute smart contract (transferfrom)
    @hasheduser = Hasheduser.find(current_user.id)
    binding.pry
    smartContract = EthereumAPI.new()
    smartContract.executeTransfer(@trade.maker_address, @hasheduser.ether_account, params[:amount].to_i, current_user.password)
    redirect_to trades_path, notice: "Success Transfer!"
  end

  def destroy
    @trade.destroy
    redirect_to trades_path, notice: "Success Cancel"
  end

  private
    def trade_params
      params.require(:trade).permit(:price, :from_token_name, :to_token_name, :from_token_amount, :to_token_amount, :maker_address).to_h
    end

    def set_trade
      @trade = Trade.find(params[:id])
    end
end
