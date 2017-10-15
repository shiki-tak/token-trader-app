class PosessionsController < ApplicationController

  def index
    @posessions = Posession.find(current_user.id)
  end
end
