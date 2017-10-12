class TradesController < ApplicationController

  def index
    @tradeinfos = Trade.all
  end

  def new
    @tradeinfo = Trade.new

  end

  def create
  end
end
