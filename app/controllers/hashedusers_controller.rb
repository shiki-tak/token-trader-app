class HashedusersController < ApplicationController
  require 'digest/md5'
  require "#{Dir.pwd}/app/models/EthereumAPI.rb"

  def createhasheduser(username, password)
    @hasheduser = Hasheduser.new
    smartContract = EthereumAPI.new()
    Digest::MD5.new.update(username).to_s
    smartContract.createGethAccount(password)
    # create geth account
    puts "#{Digest::MD5.new.update(username).to_s}"
  end
end
