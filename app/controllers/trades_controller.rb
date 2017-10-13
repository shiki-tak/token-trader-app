class TradesController < ApplicationController
  require "#{Dir.pwd}/app/models/EthereumAPI.rb"

  def index
    @trades = Trade.all
    @tokens = Token.new
    @trade = Trade.new
  end

  def new
  end

  def create
    @trade = Trade.new(trade_params)
    @trade.from_token_name =  Token.find(@trade.from_token_name.to_i).symbol
    binding.pry
    @trade.to_token_name =  Token.find(@trade.to_token_name.to_i).symbol
    @trade.to_token_amount = @trade.price * @trade.from_token_amount
    if @trade.save
      redirect_to trades_path, notice: "Success Sale's Info Set!"
    else
      render 'new'
    end
  end

  private
    def trade_params
      params.require(:trade).permit(:price, :from_token_name, :to_token_name, :from_token_amount, :to_token_amount, :maker_address).to_h
    end
end
