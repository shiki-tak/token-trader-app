class PosessionsController < ApplicationController

  def index
    # Blockchain上からtraderが所有しているTokenの一覧を取得して表示する
    @posessions = Posession.where(user_id: current_user.id)
  end

end
