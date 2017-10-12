class TradesController < ApplicationController

  def index
    @tradeinfos = Trade.all
    @tokens = Token.new
  end

  def new
    @tradeinfo = Trade.new
  end

  def create
  end
end
