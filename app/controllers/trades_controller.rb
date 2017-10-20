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
    # TODO: Trades TableのTokenの名前に関する情報を別テーブルにする
    @trade = Trade.new(trades_params)
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
    # get token address
    maker_token_address = Token.find_by(symbol: @trade.from_token_name).token_address
    taker_token_address = Token.find_by(symbol: @trade.to_token_name).token_address
    # execute smart contract (transferfrom)
    @hasheduser = Hasheduser.find(current_user.id)
    if @trade.from_token_amount < params[:amount].to_i
      puts "It exceeds the amount that can be traded"
      redirect_to trades_path, notice: "It exceeds the amount that can be traded"
    else
      maker_amount = params[:amount].to_i
      taker_amount = (maker_amount * @trade.price).to_i
      # Update Trade Table
      @trade.from_token_amount -= maker_amount
      @trade.to_token_amount -= taker_amount
      @trade.update(from_token_amount: @trade.from_token_amount, to_token_amount: @trade.to_token_amount)

      # TODO: リファクタ...
      maker_token_id = Token.find_by(symbol: @trade.from_token_name).id
      taker_token_id = Token.find_by(symbol: @trade.to_token_name).id
      maker_id = Hasheduser.find_by(ether_account: @trade.maker_address).id
      taker_id = Hasheduser.find(current_user.id).id
      # 1) Update maker token
      binding.pry
      @maker_posession_maker_token = Posession.find_by(token_id: maker_token_id, user_id: maker_id)
      if @maker_posession_maker_token == nil
        @maker_posession_maker_token = Posession.new
        binding.pry
        @maker_posession_maker_token.user_id = maker_id
        @maker_posession_maker_token.token_id = maker_token_id
        @maker_posession_maker_token.balance = maker_amount
        @maker_posession_maker_token.save
      else
        @maker_posession_maker_token.balance -= maker_amount
        @maker_posession_maker_token.update(balance: @maker_posession_maker_token.balance)
      end
      binding.pry
      @maker_posession_taker_token = Posession.find_by(token_id: taker_token_id, user_id: maker_id)
      if @maker_posession_taker_token == nil
        @maker_posession_taker_token = Posession.new
        @maker_posession_taker_token.user_id = maker_id
        @maker_posession_taker_token.token_id = taker_token_id
        @maker_posession_taker_token.balance = taker_amount
        @maker_posession_taker_token.save
      else
        @maker_posession_taker_token.balance += taker_amount
        @maker_posession_taker_token.update(balance: @maker_posession_taker_token.balance)
      end

      # 2) Update taker token
      binding.pry
      @taker_posession_maker_token = Posession.find_by(token_id: maker_token_id, user_id: taker_id)
      if @taker_posession_maker_token == nil
        @taker_posession_maker_token = Posession.new
        @taker_posession_maker_token.user_id = taker_id
        @taker_posession_maker_token.token_id = maker_token_id
        @taker_posession_maker_token.balance = maker_amount
        @taker_posession_maker_token.save
      else
        @taker_posession_maker_token.balance += maker_amount
        @taker_posession_maker_token.update(balance: @taker_posession_maker_token.balance)
      end
      binding.pry
      @taker_posession_taker_token = Posession.find_by(token_id: taker_token_id, user_id: taker_id)
      if @taker_posession_taker_token == nil
        @taker_posession_taker_token = Posession.new
        @taker_posession_taker_token.user_id = taker_id
        @taker_posession_taker_token.token_id = taker_token_id
        @taker_posession_taker_token.balance = taker_amount
        @taker_posession_taker_token.save
      else
        @taker_posession_taker_token.balance -= taker_amount
        @taker_posession_taker_token.update(balance: @taker_posession_taker_token.balance)
      end

      puts "Update Trade Table"
      puts "#{@trade.from_token_name}: #{@trade.from_token_amount}"
      puts "#{@trade.to_token_name}: #{@trade.from_token_amount}"
      smartContract = EthereumAPI.new()
      smartContract.executeTransfer(maker_token_address, taker_token_address, @trade.maker_address, @hasheduser.ether_account, maker_amount, taker_amount, @hasheduser.ether_account_password)
      redirect_to trades_path, notice: "Success Transfer!"
    end
  end

  def destroy
    @trade.destroy
    redirect_to trades_path, notice: "Success Cancel"
  end

  private
    def trades_params
      params.require(:trade).permit(:price, :from_token_name, :to_token_name, :from_token_amount, :to_token_amount).to_h
    end

    def set_trade
      @trade = Trade.find(params[:id])
    end
end
