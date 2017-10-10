class IssueController < ApplicationController
  before_action :authenticate_user!
  
  def index

  end

  def new
    @token  = Token.new
  end

  def create

  end

  def show
  end

  def destroy
  end
end
