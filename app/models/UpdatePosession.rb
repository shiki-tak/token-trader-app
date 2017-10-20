class UpdatePosession
  def updatePosessionTable(maker_token_id, taker_token_id, maker_id, taker_id, maker_amount, taker_amount)
    # TODO: さらにリファクタ...
    # 1) Update maker token
    @maker_posession_maker_token = Posession.find_by(token_id: maker_token_id, user_id: maker_id)
    if @maker_posession_maker_token == nil
      @maker_posession_maker_token = Posession.new
      @maker_posession_maker_token.user_id = maker_id
      @maker_posession_maker_token.token_id = maker_token_id
      @maker_posession_maker_token.balance = maker_amount
      @maker_posession_maker_token.save
    else
      @maker_posession_maker_token.balance -= maker_amount
      @maker_posession_maker_token.update(balance: @maker_posession_maker_token.balance)
    end
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
  end
end
