class HashedusersController < ApplicationController

  def createhasheduser(username)
    @hasheduser = Hasheduser.new
    puts "#{username}"
  end
end
